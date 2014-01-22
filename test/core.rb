require_relative "../lib/gargle/core"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Module" do
  before do
    @test_node_name = :node_name
    @test_group_name = :group_name
    @test_state_sum_key = :state_sum_key
    @test_state_sum_values = [:state_sum_values]
  end
  describe "A) initialization" do
    it "instantiates class variables correctly" do
      Gargle.class_variable_get(:@@store).must_equal []
      Gargle.class_variable_get(:@@state_sums).must_equal({})
    end
  end

  describe "B) Creates a new node" do
    it "creates a new node" do
      Gargle::node(@test_node_name)
      must_send([Gargle::GargleNode, :create_if_not_exists, @test_node_name, {}, nil])
      Gargle.class_variable_get(:@@store).length.must_equal(1)
      Gargle.class_variable_get(:@@store)[0].name.must_equal @test_node_name
      Gargle.class_variable_get(:@@store)[0].must_be_instance_of Gargle::GargleNode
    end
  end

  describe "C) Creates a new group" do
    it "creates a new group" do
      Gargle::group(@test_group_name)
      must_send([Gargle::GargleGroup, :create_if_not_exists, @test_group_name, {}, nil])
      must_send([ObjectSpace.each_object(Gargle::GargleGroup).to_a.select{|group| group.name == @test_group_name}.first, :run])
      Gargle.class_variable_get(:@@store).length.must_equal(2)
      Gargle.class_variable_get(:@@store)[1].name.must_equal @test_group_name
      Gargle.class_variable_get(:@@store)[1].must_be_instance_of Gargle::GargleGroup
      Gargle.class_variable_get(:@@store)[1].must_be_kind_of Gargle::GargleNode
    end
  end

  describe "D) Creates a state sum" do
    it "creates a state sum" do
      Gargle::state_sum(@test_state_sum_key, @test_state_sum_values)
      Gargle.class_variable_get(:@@state_sums).length.must_equal(1)
      Gargle.class_variable_get(:@@state_sums)[@test_state_sum_key].must_equal(@test_state_sum_values)
    end
  end
end