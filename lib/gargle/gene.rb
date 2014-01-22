module Gargle
  #The Gene will be evolved by the genetic algorithm
  class GargleGene < Array
    attr_accessor :run_list

    #verify that the path is valid
    def fitness
      self.run_list = GargleGraph.new(self).run_list
      if !self.run_list.blank?
        1
      else
        0
      end
    end

    #recombine genes to create new genes
    def recombine(gene)
      type_of_combination = rand
      if gene.length == self.length
        if type_of_combination > Gargle::GargleConfig.append_probability
          cross_point = (rand * gene.size-1).to_i
          gene1_head = self[0..cross_point]
          gene1_tail = self[cross_point+1..self.length-1]
          gene2_head = gene[0..cross_point]
          gene2_tail = gene[cross_point+1..gene.length-1]
          if type_of_combination < Gargle::GargleConfig.head_first_recombine_probability
            return GargleGene.new(gene1_head + gene2_tail)
          else
            return GargleGene.new(gene2_head + gene1_tail)
          end
        end
      end
      if type_of_combination > Gargle::GargleConfig.head_first_append_probability
        return GargleGene.new(gene + self)
      else
        return GargleGene.new(self + gene)
      end
    end

    #Random mutation to avoid local maxima
    def mutate
      mutate_probability = Gargle::GargleConfig.initial_mutate_probability
      cumulative_mutation = rand
      mutate_up_or_down = rand
      mutation_coefficient =rand
      while mutate_probability > cumulative_mutation
        mutate_reduction = rand
        mutate_point = (rand * self.size).to_i
        if mutate_up_or_down > Gargle::GargleConfig.mutate_down_probability
          self[mutate_point] = (self[mutate_point] / mutation_coefficient).to_i
        else
          self[mutate_point] = (self[mutate_point] * mutation_coefficient).to_i
        end
        mutate_probability = mutate_probability * mutate_reduction
      end
    end
  end
end