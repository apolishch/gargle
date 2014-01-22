require "gga4r"
require_relative "graph"
require_relative "error"
require_relative "genome"
require_relative "group"
require_relative "gene"
require_relative "../config/config"
require_relative "../utils/object"

# This program will allow you to create stochastic path through a predefined collection of nodes.
# Gargle stands for Genetic Algorithm on the Ruby Graph Library Emulation

module Gargle

  #A global array to ensure that references to Nodes are not Garbage Collected prematurely
  @@store = []

  #A global array holding all currently defined state sums
  @@state_sums = {}

  #Node instantiation
  def self.node(name, params={}, &block)
    node = GargleNode.create_if_not_exists(name,params, block)
  end #node

  #Group instantiation
  def self.group(name, params={}, &block)
    group = GargleGroup.create_if_not_exists(name,params, block)
    group.run
  end #group

  #Add a state sum to the array.
  def self.state_sum(name, constituents)
    @@state_sums[name]=constituents
  end
end