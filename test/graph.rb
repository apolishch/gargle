require_relative "../lib/gargle/graph"
require_relative "../lib/gargle/core"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Graph" do
  before do

  end
  describe "A) initialization" do
    it "instantiates class variables correctly" do
      assert Proc === Gargle::GargleGraph.class_variable_get(:@@item_in_forbidden_state)
      assert Proc === Gargle::GargleGraph.class_variable_get(:@@item_matches_required_states)
      assert Proc === Gargle::GargleGraph.class_variable_get(:@@valid_items)
    end
  end

  describe "B) item_in_forbidden_state" do
    before do
      @item = Gargle.node :node, {forbidden_states: [:foobar, :bazz]}
    end
    describe "when item is in forbidden state" do
      describe "when this is due to a state" do
        before do
          @states = [:bazz]
          @state_sums = {}
        end
        it "item is forbidden due to a state" do
          forbidden = Gargle::GargleGraph.class_variable_get(:@@item_in_forbidden_state).call(@item, @states, @state_sums)
          forbidden.must_equal(true)
        end
      end

      describe "when this is due to a state sum" do
        before do
          @states = [:foo, :bar]
          @state_sums = {foobar: @states}
        end
        it "item is forbidden due to a state sum" do
          forbidden = Gargle::GargleGraph.class_variable_get(:@@item_in_forbidden_state).call(@item, @states, @state_sums)
          forbidden.must_equal(true)
        end
      end
    end

    describe "when item is not in forbidden state" do
      before do
        @states = [:blah, :blooh]
        @state_sums = {beepboop: [:beep, :boop]}
      end
      it "item is not forbidden" do
        forbidden = Gargle::GargleGraph.class_variable_get(:@@item_in_forbidden_state).call(@item, @states, @state_sums)
        forbidden.must_equal(false)
      end
    end

  end

  describe "C) item_matches_required_states" do
    describe "when item matches required states" do
      before do
        @item = Gargle.node :node, {required_states: [:foobar, :bazz]}
        @state_sums = {foobar: [:foo, :bar]}
        @states = [:foo, :bar, :bazz]
      end
      it "item matches required states" do
        required = Gargle::GargleGraph.class_variable_get(:@@item_matches_required_states).call(@item, @states, @state_sums)
        required.must_equal(true)
      end
    end

    describe "when item does not match required states" do
      before do
        @item = Gargle.node :node, {required_states: [:foobar, :bazz, :blah]}
        @state_sums = {foobar: [:foo, :bar]}
        @states = [:foo, :bazz]
      end
      it "item does not match required states" do
        required = Gargle::GargleGraph.class_variable_get(:@@item_matches_required_states).call(@item, @states, @state_sums)
        required.must_equal(false)
      end
    end

  end

  describe "D) valid_items" do
    before do
      @valid_item = Gargle.node :valid_item, {required_states: [:foobar]}
      @invalid_item_forbidden = Gargle.node :invalid_item, {forbidden_states: [:bazz]}
      @invalid_item_required = Gargle.node :invalid_item2, {required_states: [:blah]}
      @state_sums = {foobar: [:foo, :bar]}
      @items = [@valid_item, @invalid_item_forbidden, @invalid_item_required]
      @states = [:foo, :bar, :bazz]
      Gargle.class_variable_set(:@@state_sums, @state_sums)
    end

    it "returns the right items" do
      valid = Gargle::GargleGraph.class_variable_get(:@@valid_items).call(@items, @states)
      valid.must_equal [@valid_item]
    end
  end

  describe "E) initialize" do
    before do
      @valid_item = Gargle.node :valid_item, {required_states: [:awesome], states_removed: [:awesome]}
      @initially_valid_item = Gargle.node :valid_item2, {states_set: [:awesome], forbidden_states: [:awesome]}
      @invalid_item = Gargle.node :invalid_item, {required_states: [:non_awesome]}
    end
    it "initialize valid1" do
      gg = Gargle::GargleGraph.new([0, 0])
      gg.run_list.must_equal [@initially_valid_item, @valid_item]
      gg.states.must_equal []
    end

    it "initialize valid2" do
      gg = Gargle::GargleGraph.new([0])
      gg.run_list.must_equal [@initially_valid_item]
      gg.states.must_equal [:awesome]
    end

    it "initialize invalid" do
      gg = Gargle::GargleGraph.new([17])
      gg.run_list.must_equal nil
      gg.states.must_equal []
    end

  end

  describe "F) list run" do
    before do
      module Gargle
        class GargleGene < Array
          def fitness
            true
          end
        end
      end
    end
    describe "for invalid target raises error" do
      before do
        @valid_item = Gargle.node :valid_item, {required_states: [:awesome], states_removed: [:awesome]}
        @initially_valid_item = Gargle.node :valid_item2, {states_set: [:awesome], forbidden_states: [:awesome]}
      end

      it "raises an error" do
        begin
          Gargle::GargleGraph.list_run([@valid_item.name])
        rescue Exception => e
          e.must_be_instance_of Gargle::GargleError
          e.message.must_equal "You passed an impossible run list. The node valid_item could not run."
        end
      end

      it "returns the right array" do
        path = Gargle::GargleGraph.list_run([@initially_valid_item.name, @valid_item.name, @initially_valid_item.name])
        must_send([Gargle::GargleGene, :new])
        path.must_equal([0,0,0])
      end
    end

  end

  describe "G) generate valid path" do
    before do
      @valid_item = Gargle.node :valid_item, {states_set: [:awesome], forbidden_states: [:awesome]}
      module Gargle
        class GargleGene < Array
          def fitness
            true
          end
        end
        class GargleGraph
          class << self
            def list_run(items=nil)
              true
            end
          end
        end
        class GargleConfig
          class << self
            def continuation_probability
              1
            end
          end
        end
      end
    end

    it "for run_type list" do
      Gargle::GargleGraph.generate_valid_path([1,2,3], "list")
      must_send [Gargle::GargleGraph, :list_run, [1,2,3]]
    end

    it "for empty run list" do
      begin
        Gargle::GargleGraph.generate_valid_path([], "list")
      rescue Exception => e
        e.must_be_instance_of Gargle::GargleError
        e.message.must_equal "You passed an empty run list"
      end
    end

    it "for run type set" do
      path = Gargle::GargleGraph.generate_valid_path([:valid_item], "set")
      must_send [Gargle::GargleConfig, :continuation_probability]
      path = []
    end
  end
end