# frozen_string_literal: true

module Serval
  module Api
    module Helpers
      # TODO: define my own validation for param format here.

      def sparql_query_string(resource_type, resource_instance)
        case resource_type
        when 'actor'
          "SELECT DISTINCT ?film
          WHERE { ?film a dbo:Film .
                  ?film dbo:starring dbr:#{resource_instance} . }"
        when 'film'
          "SELECT DISTINCT ?actor
          WHERE {
            dbr:#{resource_instance} dbo:starring ?actor . }"
        end
      end
    end
  end
end
