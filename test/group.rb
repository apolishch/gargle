require_relative "../lib/gargle/group"
require_relative "../lib/utils/object"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Group" do
  before do
  end
  describe "A) in flight" do
    before do
      @in_flight = :foo
      Gargle::GargleGroup.class_variable_set(:@@group_in_flight, @in_flight)
    end
    it "returns the right in flight" do
      in_flight = Gargle::GargleGroup.in_flight
      in_flight.must_equal @in_flight
    end
  end

  describe "B) run" do
    before do
      Gargle.class_variable_set(:@@store, [])
      module Gargle
        class GargleNode
          def run
            true
          end
        end
      end
      @group = Gargle::GargleGroup.new(:bar)
    end
    it "runs" do
      @group.run
      #figure out a way to test this
      #must_send [@group, :super]
      #must_send [@group, :"Gargle::GargleGroup.run"]
    end
  end
end