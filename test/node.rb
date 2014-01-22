require_relative "../lib/gargle/group"
require_relative "../lib/utils/object"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Node" do
  before do
  end
  describe "A) merge parent" do
    before do
      Gargle.class_variable_set(:@@store, [])
      @group_states = {required_states: [:foo], forbidden_states: [:bar], states_set: [:bazz], states_removed: [:blah]}
      @group = Gargle::GargleGroup.new :group, @group_states
      @grouped_node_name = :"group::node"
    end

    it "merges correctly" do
      node = Gargle::GargleNode.new @grouped_node_name
      node.required_states.must_equal @group_states[:required_states]
      node.forbidden_states.must_equal @group_states[:forbidden_states]
      node.states_set.must_equal @group_states[:states_set]
      node.states_removed.must_equal @group_states[:states_removed]
    end
  end

  describe "B) initialize" do
    before do
      module Gargle
        class GargleNode
          def update_attrs(foo=nil)
            true
          end
          def merge_parent
            true
          end
        end
      end
      Gargle.class_variable_set(:@@store, [])
      @node = :node
    end
    it "calls methods" do
      node = Gargle::GargleNode.new @node
      must_send [node, :update_attrs]
      must_send [node, :merge_parent]
      Gargle.class_variable_get(:@@store).must_include node
    end
  end

  describe "C) run" do
    before do
      node = :node_run
      @node = Gargle::GargleNode.new node
      @node.block = lambda do
        true
      end
    end
    it "run" do
      @node.run
      must_send [@node.block, :try, :call]
    end
  end

  describe "D) create_if_not_exists" do
    before do
      module Gargle
        class GarlgeNode
          def update_attrs(foo=nil)
            true
          end
          def initialize
            true
          end
        end
        class GargleError < StandardError

        end
      end
    end
    describe "for invalid name type" do
      it "throws an error" do
        begin
          Gargle::GargleNode.create_if_not_exists(123)
        rescue Exception => e
          e.must_be_instance_of Gargle::GargleError
          e.message.must_equal "Something seriously wrong has occurred. Please verify."
        end
      end
    end

    describe "for valid name type" do
      before do
        @name_new = :name_new
        @name_old = :name_exists
        @params = {required_states: [:foo], forbidden_states: [:bar]}
        @old_node = Gargle::GargleNode.new @name_old
      end
      it "for a new node" do
        Gargle::GargleNode.create_if_not_exists(@name_new, @params)
        must_send [Gargle::GargleNode, :new, @name_new, @params]
      end

      it "for an update on an existing node" do
        Gargle::GargleNode.create_if_not_exists(@name_old, @params)
        must_send [@old_node, :update_attrs, [@name_old, @params]]
      end
    end
  end
end