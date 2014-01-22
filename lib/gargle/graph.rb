module Gargle
  #This Class stores valid runs through the 'graph'
  class GargleGraph

    #run_list refers to the particular path chose, while states is an array that keeps track of the application state
    attr_accessor :run_list, :states

    #Check if a given node would currently clash on state
    @@item_in_forbidden_state = lambda do |item, states, state_sums|
      forbidden = Array.new(item.forbidden_states)
      if forbidden.empty?
        forbidden = false
      else
        catch (:done) do
          forbidden.each do |fb|
            if states.index(fb)
              forbidden = true
              throw :done
            else
              state_sums.each do |key, value|
                illegal = true
                if forbidden.index(key)
                  value.each do |v|
                    if !states.index(v)
                      break
                    end
                    if illegal
                      forbidden = illegal
                      break
                    end
                  end
                end
                if forbidden.class == TrueClass
                  throw :done
                end
              end
            end
          end
        end
      end
      forbidden = ([TrueClass, FalseClass].index(forbidden.class) ? forbidden: false)
      forbidden
    end

    #Check if a given node has all of its required_states fulfilled
    @@item_matches_required_states = lambda do |item, states, state_sums|
      required = Array.new(item.required_states)
      item.required_states.each do |rs|
        if state_sums[rs]
          required.delete(rs)
          required << state_sums[rs]
          required.flatten!
        end
      end
      required.uniq!
      required.delete_if{|rq| states.index(rq)}
      required.length == 0
    end

    #Find all currently valid nodes
    @@valid_items = lambda do |items, states|
      state_sums = Gargle.class_variable_get(:@@state_sums)
      items.select do |item|
        required = @@item_matches_required_states.call(item, states, state_sums)
        forbidden = @@item_in_forbidden_state.call(item,states, state_sums)
        required && !forbidden
      end
    end

    #Given a node selection order by the gene, verifies that the resulting path would be valid
    def initialize(gene)
      self.run_list = GargleGene.new
      self.states = Array.new
      all_nodes = ObjectSpace.each_object(GargleNode).to_a.select {|item| item.class != GargleGroup}.uniq {|item| item.name}
      gene.each do |g|
        currently_valid = @@valid_items.call(all_nodes, self.states)
        if currently_valid.length >= g+1
          self.run_list << currently_valid[g]
          currently_valid[g].states_set.each do |ss|
            self.states << ss
            self.states.uniq!
          end
          currently_valid[g].states_removed.each do |rs|
            self.states.delete(rs)
          end
        else
          self.run_list = nil
          break
        end
      end
      self.run_list
    end #initialize

    class << self

      #Generates a stochastic path through the Graph that is known to be valid
      def generate_valid_path(target_nodes, run_type)
        if run_type == "set"
          path = GargleGene.new
          all_nodes = ObjectSpace.each_object(GargleNode).to_a.select {|item| item.class != GargleGroup}.uniq {|item| item.name}
          keep_building = 0
          run_list = []
          states = []
          while keep_building < Gargle::GargleConfig.continuation_probability
            keep_building = rand
            currently_valid = @@valid_items.call(all_nodes, states)
            target_nodes.each do |tn|
              if run_list.map(&:name).index(tn).nil?
                keep_building = 0
              end
            end
            if currently_valid.length == 0
              keep_building = 1
            else
              next_step = rand(currently_valid.length)
              path << next_step
              next_step = currently_valid[next_step]
              run_list << next_step
              next_step.states_set.each do |ss|
                states << ss
                states.uniq!
              end
              next_step.states_removed.each do |rs|
                states.delete(rs)
              end
            end
          end
          path.fitness
          return path
        elsif target_nodes.blank?
          raise GargleError.new(), "You passed an empty run list"
        else
          self.list_run(target_nodes)
        end
      end

      #Runs a deterministic, defined path through the graph if that path is valid.
      def list_run(target_nodes)
        path = GargleGene.new
        all_nodes = ObjectSpace.each_object(GargleNode).to_a.select {|item| item.class != GargleGroup}.uniq {|item| item.name}
        states = []
        target_nodes.each do |tn|
          currently_valid = @@valid_items.call(all_nodes, states)
          if currently_valid.map(&:name).index(tn)
            path << currently_valid.map(&:name).index(tn)
            currently_valid[currently_valid.map(&:name).index(tn)].states_set.each do |ss|
              states << ss
              states.uniq!
            end
            currently_valid[currently_valid.map(&:name).index(tn)].states_removed.each do |rs|
              states.delete(rs)
            end
          else
            raise GargleError.new(), "You passed an impossible run list. The node #{tn} could not run."
          end
        end
        path.fitness
        path
      end
    end
  end #GargleGraph


end