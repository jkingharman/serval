# frozen_string_literal: true

module Serval
  module Api
    class DBpediaSparql < Grape::API
      helpers do
        include Api::Helpers

        def cache
          @@cache ||= {}
        end

        def sparql_service
          @sparql_service ||= Services::Sparql.new
        end
      end

      params do
        # TODO: Add regex.
        optional :film, type: String, allow_blank: false
        optional :actor, type: String, allow_blank: false
        exactly_one_of :film, :actor
      end
      get '/' do
        resource_type = declared(params, include_missing: false).keys.first
        resource_instance = declared(params)[resource_type]

        cache.fetch("#{resource_type}-#{resource_instance}") do
          query = sparql_query_string(resource_type, resource_instance)
          result = sparql_service.query(query)

          cache["#{resource_type}-#{resource_instance}"] = result
        end
      end
    end
  end
end
