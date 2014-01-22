module Gargle
  class GargleConfig
    class << self
      def initial_mutate_probability
        @initial_mutate_probability ||= ENV['INITIAL_MUTATE_PROBABILITY'] ? ENV['INITIAL_MUTATE_PROBABILITY'] : 1
        @initial_mutate_probability
      end

      def mutate_down_probability
        @mutate_down_probability ||= ENV['MUTATE_DOWN_PROBABILITY'] ? ENV['MUTATE_DOWN_PROBABILITY'] : 0.5
        @mutate_down_probability
      end

      def append_probability
        @append_probability ||= ENV['APPEND_PROBABILITY'] ? ENV['APPEND_PROBABILITY'] : 0.05
        @append_probability
      end

      def head_first_recombine_probability
        @head_first_recombine_probability ||= ENV['HEAD_FIRST_RECOMBINE_PROBABILITY'] ? ENV['HEAD_FIRST_RECOMBINE_PROBABILITY'] : 0.525
        @head_first_recombine_probability
      end

      def head_first_append_probability
        @head_first_append_probability ||= ENV['HEAD_FIRST_APPEND_PROBABILITY'] ? ENV['HEAD_FIRST_APPEND_PROBABILITY'] : 0.5
        @head_first_append_probability
      end

      def population_size
        @population_size ||= ENV['POPULATION_SIZE'] ? ENV['POPULATION_SIZE'] : 5
        @population_size
      end

      def initial_population_size
        @initial_population_size ||= ENV['INITIAL_POPULATION_SIZE'] ? ENV['INITIAL_POPULATION_SIZE'] : 5
        @initial_population_size
      end

      def continuation_probability
        @continuation_probability ||= ENV['CONTINUATION_PROBABILITY'] ? ENV['CONTINUATION_PROBABILITY'] : 0.99
        @continuation_probability
      end
    end
  end
end