# frozen_string_literal: true

module Serval
  module Services
    class Sparql
      DEFAULT_ENDPOINT = 'http://dbpedia.org/sparql'

      def initialize
        @client = SPARQL::Client.new(DEFAULT_ENDPOINT)
      end

      # add retry logic.
      def query(sparql_query)
        result = client.query(sparql_query)

        if result.respond_to?(:bindings)
          format_solutions_hash(hashify_solutions(result))
        end
      end

      private

      attr_reader :client

      def hashify_solutions(solutions)
        solutions.bindings.transform_values do |bound_vals|
          bound_vals.map(&:value)
        end
      end

      def format_solutions_hash(solutions)
        solutions = solutions.transform_values do |vals|
          vals.map { |val| val.split('/').last }
        end
        solutions.transform_keys { |key| key.to_s + 's' }
      end
    end
  end
end
