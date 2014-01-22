module Gargle
  #Some fancier details about the error in question are yet to come
  class GargleError < StandardError
    attr_reader :object
    def initialize(object = nil)
      @object = object
    end
  end
end