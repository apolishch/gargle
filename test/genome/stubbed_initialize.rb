require_relative "../../lib/gargle/genome"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Genome" do
  describe "A) generate_initial_gene" do
    before do
      module Gargle
        class GargleGraph
          class << self
            def generate_valid_path(foo,bar)
              true
            end
          end
        end
      end
    end
    it "passes the buck" do
      Gargle::GargleGenome.generate_initial_gene(:foo, :bar)
      must_send([Gargle::GargleGraph, :generate_valid_path, :foo, :bar])
    end
  end

  describe "B) Runs a genome" do
    before do
      module Gargle
        class GargleGenome
          def initialize
            true
          end
        end
        class GargleGene

        end
      end
      @test_genome = Gargle::GargleGenome.new
    end
    describe "given an array" do
      before do
        class Runnable
          def run
            true
          end
          def name
            true
          end
        end
        @runnable = Runnable.new
        @list = [@runnable]
      end
      it "given an array" do
        @test_genome.run(@list)
        must_send([@runnable, :run])
        must_send([@runnable, :name])
      end
    end

    describe "not given an array" do
      it "not given an array" do
        @test_genome.run
        must_send([Gargle::GargleGenome, :new])
      end
    end
  end
  #
  #describe "C) Creates a new group" do
  #  it "creates a new group" do
  #    Gargle::group(@test_group_name)
  #    must_send([Gargle::GargleGroup, :create_if_not_exists, @test_group_name, {}, nil])
  #    must_send([ObjectSpace.each_object(Gargle::GargleGroup).to_a.select{|group| group.name == @test_group_name}.first, :run])
  #    Gargle.class_variable_get(:@@store).length.must_equal(2)
  #    Gargle.class_variable_get(:@@store)[1].name.must_equal @test_group_name
  #    Gargle.class_variable_get(:@@store)[1].must_be_instance_of Gargle::GargleGroup
  #    Gargle.class_variable_get(:@@store)[1].must_be_kind_of Gargle::GargleNode
  #  end
  #end
  #
  #describe "D) Creates a state sum" do
  #  it "creates a state sum" do
  #    Gargle::state_sum(@test_state_sum_key, @test_state_sum_values)
  #    Gargle.class_variable_get(:@@state_sums).length.must_equal(1)
  #    Gargle.class_variable_get(:@@state_sums)[@test_state_sum_key].must_equal(@test_state_sum_values)
  #  end
  #end
end