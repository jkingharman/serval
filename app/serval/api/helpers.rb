# frozen_string_literal: true

module Serval
  module Api
    module Helpers
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

      def validate_resource!(instance)
        instance.chomp!("_")
        not_all_caps = !(instance.upcase == instance)
        alphanum_snake_case = /^([A-Z0-9][a-z0-9]{0,}_{0,1})+$/

        unless alphanum_snake_case.match?(instance) && not_all_caps
          raise(
            Grape::Exceptions::ValidationErrors,
            params: [instance],
            message: "Invalid format for film or actor"
          )
        end
      end
    end
  end
end
