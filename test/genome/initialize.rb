require_relative "../../lib/gargle/genome"
require_relative "../../lib/utils/object"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Genome" do
  describe "A) initializes a Genome" do
    before do
      module Gargle
        class GargleGenome
          class << self
            def generate_initial_gene(foo, bar)
              true
            end
          end
        end
      end
    end
    describe "for invalid target nodes type" do
      before do
        @target_nodes = :foo
        module Gargle
          class GargleError < StandardError

          end
        end
      end
      it "for invalid target nodes type" do
        begin
          Gargle::GargleGenome.new(@target_nodes)
        rescue Exception => e
          e.message.must_equal "Your target nodes list must be an Array"
          e.must_be_instance_of Gargle::GargleError
        end
      end
    end

    describe "for valid target nodes type" do
      before do
        module Gargle
          class GargleGene

          end
          class GargleGenome
            def run(foo=nil)
              true
            end
          end
          class GargleConfig
            class << self
              def population_size
                2
              end
              def initial_population_size
                1
              end
            end
          end
        end
        class Runnable
          def run_list
            :foo
          end
          def fitness
            1
          end
        end
        class GeneticAlgorithm
          def initialize(foo=nil)
            @population = [Runnable.new]
          end
          def evolve
            true
          end
        end
      end
      it "for run type list" do
        @test_genome = Gargle::GargleGenome.new([], "list")
        must_send [GeneticAlgorithm, :new]
        must_send [ObjectSpace.each_object(GeneticAlgorithm).to_a[0], :evolve]
        must_send [Gargle::GargleGenome, :generate_initial_gene, [], "list"]
        must_send [@test_genome, :run, :foo]
      end

      it "for invalid run type" do
        begin
          @test_genome = Gargle::GargleGenome.new([], "foo")
        rescue Exception => e
          e.message.must_equal "You passed an invalid run_type, please pass either 'set' or 'list'"
          e.must_be_instance_of Gargle::GargleError
        end
      end

      it "for run type set" do
        @test_genome = Gargle::GargleGenome.new([], "set")
        must_send [GeneticAlgorithm, :new]
        must_send [ObjectSpace.each_object(GeneticAlgorithm).to_a[0], :evolve]
        must_send [Gargle::GargleGenome, :generate_initial_gene, [], "set"]
        must_send [@test_genome, :run]
      end
    end
  end
end