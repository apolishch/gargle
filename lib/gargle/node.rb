module Gargle
  class GargleNode
    #required_states references the states which must be in @@states for this node to be valid, forbidden references the states which MUST NOT be in
    #@@states for this to be valid. states_set and states_removed reference states transitions this node will execute upon running
    attr_accessor :name, :required_states, :forbidden_states, :states_set, :states_removed, :block, :group


    def initialize(name, *attrs)
      self.name = name
      self.update_attrs(attrs)
      self.merge_parent
      Gargle.class_variable_set(:@@store, Gargle.class_variable_get(:@@store)<<self)
    end #initialize

    def merge_parent
      if self.group
        parent = ObjectSpace.each_object(GargleGroup).select{|item| item.name == self.group}[0]
        self.instance_variables.select{|ivar| self.instance_variable_get(ivar).class == Array}.map do |ivar|
          new_ivar = self.instance_variable_get(ivar)
          new_ivar << parent.instance_variable_get(ivar)
          new_ivar.flatten!
          new_ivar.compact!
          self.instance_variable_set(ivar, new_ivar)
        end
      end
    end

    def update_attrs(*attrs)
      attrs.try(:flatten!, 2)
      self.required_states = attrs.try(:[], 0) ? (attrs[0][:required_states] || []) : []
      self.forbidden_states = attrs.try(:[], 0) ? (attrs[0][:forbidden_states] || []) : []
      self.states_set = attrs.try(:[], 0) ? (attrs[0][:states_set] || []) : []
      self.states_removed = attrs.try(:[], 0) ? (attrs[0][:states_removed] || []) : []
      self.block = attrs.try(:[], attrs.try(:length).try(:-, 1)) || nil
      name_delimiter = name.to_s.rindex(/::/)
      if name_delimiter
        self.group = name.to_s[0..name_delimiter-1].to_sym
      else
        self.group = nil
      end
    end

    def run
      self.block.try(:call)
    end

    class << self
      #either create a new node with the given name, or return the existing node and update its attributes
      def create_if_not_exists(name, *attrs)
        if name.class == Symbol
          node = (name.match(/::/).nil? ? "#{GargleGroup.in_flight.to_s}::#{name}".to_sym : name).to_s.gsub(/^::/, '').to_sym
          ObjectSpace.each_object(self) do |item|
            if item.name == node
              unless attrs.empty?
                item.update_attrs([attrs])
              end
              return item
            end
          end
          return self.new(node, attrs)
        else
          raise GargleError.new(), "Something seriously wrong has occurred. Please verify."
        end
      end #create_if_not_exists
    end

  end #GargleNode
end