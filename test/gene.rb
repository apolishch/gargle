require_relative "../lib/gargle/gene"
require_relative "../lib/utils/object"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Gene" do

  describe "A) fitness" do
    before do
      @test_gene = Gargle::GargleGene.new
    end
    describe "for an empty run list" do
      before do
        module Gargle
          class GargleGraph
            def initialize(attrs)

            end

            def run_list
              []
            end
          end
        end
      end

      it "for an empty run list" do
        must_send([Gargle::GargleGraph, :new, @test_gene])
        @test_gene.fitness.must_equal(0)
      end
    end

    describe "for a non empty run list" do
      before do
        module Gargle
          class GargleGraph
            def initialize(attrs)

            end

            def run_list
              [1,2,3]
            end
          end
        end
      end

      it "for a non empty run list" do
        must_send([Gargle::GargleGraph, :new, @test_gene])
        @test_gene.fitness.must_equal(1)
      end
    end
  end

  describe "B) recombination" do
    before do
      @test_gene_one = Gargle::GargleGene.new([1,2,3,4])
      @test_gene_two = Gargle::GargleGene.new([5,6,7,8])
    end
    describe "for head first recombination" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def append_probability
                0
              end

              def head_first_recombine_probability
                1
              end
            end
          end
        end
      end
      it "for head first recombination" do
        new_gene = @test_gene_one.recombine(@test_gene_two)
        new_gene.length.must_equal(4)
        new_gene[0].must_equal(1)
        new_gene[3].must_equal(8)
      end
    end
    describe "for tail first recombination" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def append_probability
                0
              end

              def head_first_recombine_probability
                0
              end
            end
          end
        end
      end

      it "for tail first recombination" do
        new_gene = @test_gene_one.recombine(@test_gene_two)
        new_gene.length.must_equal(4)
        new_gene[0].must_equal(5)
        new_gene[3].must_equal(4)
      end
    end
    describe "for head first append" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def append_probability
                1
              end

              def head_first_append_probability
                1
              end
            end
          end
        end
      end
      it "for head first append" do
        new_gene = @test_gene_one.recombine(@test_gene_two)
        new_gene.must_equal([1,2,3,4,5,6,7,8])
      end
    end
    describe "for tail first append" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def append_probability
                1
              end

              def head_first_append_probability
                0
              end
            end
          end
        end
      end
      it "for tail first append" do
        new_gene = @test_gene_one.recombine(@test_gene_two)
        new_gene.must_equal([5,6,7,8,1,2,3,4])
      end
    end
  end

  describe "C) mutation" do
    before do
      @initial_test_gene = Gargle::GargleGene.new([1,2,3,4])
      @test_gene = Gargle::GargleGene.new([1,2,3,4])
    end
    describe "for zero mutate probability" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def initial_mutate_probability
                0
              end
            end
          end
        end
      end
      it "for zero mutate probability" do
        @test_gene.mutate
        @test_gene.must_equal @initial_test_gene
      end
    end
    describe "for up mutation" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def initial_mutate_probability
                1
              end
              def mutate_down_probability
                0
              end
            end
          end
        end
      end
      it "for up mutation" do
        @test_gene.mutate
        @test_gene.length.must_equal(@initial_test_gene.length)
        @test_gene.wont_equal(@initial_test_gene)
        @test_gene.each_with_index do |i, index|
          if @initial_test_gene[index] != i
            i.must_be(:>, @initial_test_gene[index])
          end
        end
      end
    end
    describe "for down mutation" do
      before do
        module Gargle
          class GargleConfig
            class << self
              def initial_mutate_probability
                1
              end
              def mutate_down_probability
                1
              end
            end
          end
        end
      end
      it "for down mutation" do
        @test_gene.mutate
        @test_gene.length.must_equal(@initial_test_gene.length)
        @test_gene.wont_equal(@initial_test_gene)
        @test_gene.each_with_index do |i, index|
          if @initial_test_gene[index] != i
            i.must_be(:<, @initial_test_gene[index])
          end
        end
      end
    end
  end
end