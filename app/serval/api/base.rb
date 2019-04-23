# frozen_string_literal: true

module Serval
  module Api
    class Base < Grape::API
      format :json

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        Rack::Response.new(
          [{ error: e.message }.to_json],
           400,
          'Content-type' => 'text/error'
        )
      end

      rescue_from :all do |_e|
        error_msg = 'Internal server error'
        Rack::Response.new(
          [{ error: error_msg }.to_json],
          500,
          'Content-type' => 'text/error'
        )
      end

      mount Api::DBpediaSparql
    end
  end
end
