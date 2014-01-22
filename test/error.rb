require_relative "../lib/gargle/error"
require "minitest/spec"
require "minitest/autorun"

describe "Gargle Error" do
  before do
    @test_error_object = :error
  end
  describe "A) initialization" do

    it "instantiates ivars correctly" do
      test_error = Gargle::GargleError.new(@test_error_object)
      test_error.object.must_equal @test_error_object
    end
  end
end