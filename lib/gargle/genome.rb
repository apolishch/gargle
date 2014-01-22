module Gargle
  class GargleGenome

    #Runs a particular set of node blocks
    def run(list = nil)
      if list.class == Array || list.class == GargleGene
        puts "The run list is #{list.map(&:name)}"
        list.each do |list_item|
          list_item.run
        end
      else
        list = self.class.new
      end
    end

    #Instantiates, the graph, genome, and runs.
    def initialize(target_nodes = [], run_type = "set")
      if target_nodes.class != Array
        raise GargleError.new(), "Your target nodes list must be an Array"
      end
      run_type.downcase!
      run_type.strip!
      if run_type == "set"
        @population = []
        @num_generations = rand(Gargle::GargleConfig.population_size)
        initial_size = rand(Gargle::GargleConfig.initial_population_size)+1
        initial_size.times do |i|
          @population << GargleGenome.generate_initial_gene(target_nodes, run_type)
        end
        @population = @population.uniq
        @ga = GeneticAlgorithm.new(@population)
        @num_generations.times do |g|
          @ga.evolve
        end
        @population = @ga.instance_variable_get("@population").uniq.select{|pop| pop.fitness == 1}
        puts "The population is #{@population.inspect}"
        (@population.size-1).downto(0) do |item_to_run|
          if @population[item_to_run].try(:run_list)
            temp_nodes = target_nodes.select do |tn|
              @population[item_to_run].run_list.map(&:name).index(tn).nil?
            end
            if temp_nodes.empty?
              self.run(@population[item_to_run].run_list)
              break
            elsif item_to_run == 0
              raise GargleError.new(), "An internal error has occurred"
            end
          elsif item_to_run == 0
            raise GargleError.new(), "An internal error has occurred"
          end
        end
      elsif run_type == "list"
        ga = GeneticAlgorithm.new([GargleGenome.generate_initial_gene(target_nodes, run_type)])
        ga.evolve
        self.run(ga.instance_variable_get("@population")[0].run_list)
      else
        raise GargleError.new(), "You passed an invalid run_type, please pass either 'set' or 'list'"
      end
    end

    class << self

      #A wrapper to generate a known valid gene
      def generate_initial_gene(target_nodes, run_type)
        GargleGraph.generate_valid_path(target_nodes, run_type)
      end
    end
  end
end