# frozen_string_literal: true

module Serval
  module Api
    class DBpediaSparql < Grape::API
      helpers do
        include Api::Helpers

        def cache
          @@cache ||= {}
        end
      end

      params do
        optional :film, type: String
        optional :actor, type: String
        exactly_one_of :film, :actor
      end
      get '/' do
        resource_type = declared(params, include_missing: false).keys.first
        resource_instance = declared(params)[resource_type]
        validate_resource!(resource_instance)

        cache.fetch("#{resource_type}-#{resource_instance}") do
          query = sparql_query_string(resource_type, resource_instance)
          result = Services::Sparql.new.query(query)

          cache["#{resource_type}-#{resource_instance}"] = result
        end
      end
    end
  end
end
