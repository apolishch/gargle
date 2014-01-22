module Gargle
  #Groups provide namespacing for nodes, as well as the ability to group state expectations and transitions on a subset of nodes.
  require_relative "node"
  class GargleGroup < GargleNode
    class << self
      def in_flight
        @@group_in_flight
      end
    end

    def run
      current_scope = @group_in_flight
      @@group_in_flight = self.name

      super

      @@group_in_flight = current_scope
    end

    @@group_in_flight = :""
  end #GargleGroup
end