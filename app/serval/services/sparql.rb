# frozen_string_literal: true

module Serval
  module Services
    class Sparql
      DEFAULT_ENDPOINT = 'http://dbpedia.org/sparql'

      def initialize
        @retries = 5
        @client = SPARQL::Client.new(DEFAULT_ENDPOINT)
      end

      def query(sparql_query)
        begin
          result = @client.query(sparql_query)
        rescue SPARQL::Client::ServerError => e
          @retries -= 1

          @retries.positive? ? retry : error!(e, 500)
        rescue SPARQL::Client::ClientError => e
          error!(e, 500)
        end

        if result.respond_to?(:bindings)
          format_solutions_hash(hashify_solutions(result))
        end
      end

      private

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
