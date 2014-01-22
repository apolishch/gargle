require_relative "../lib/utils/object"
require "minitest/spec"
require "minitest/autorun"

describe "Object Utils" do
  before do
    class TestObject < Object
      def foo
        true
      end
    end
    @test_object = TestObject.new
  end
  describe "A) try" do
    it "calls defined method" do
      @test_object.try(:foo)
      must_send([@test_object, :foo])
    end
  end

  describe "B) blank" do
    it "nil" do
      nil.blank?.must_equal true
    end

    it "empty array" do
      [].blank?.must_equal true
    end

    it "empty hash" do
      {}.blank?.must_equal true
    end

    it "empty string" do
      "".blank?.must_equal true
    end

    it "non empty array" do
      [1,2,3].blank?.must_equal false
    end

    it "non empty object" do
      {1=>2, 3=>4}.blank?.must_equal false
    end

    it "non empty string" do
      "123".blank?.must_equal false
    end
  end
end