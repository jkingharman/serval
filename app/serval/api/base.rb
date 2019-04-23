# frozen_string_literal: true

module Serval
  module Api
    class Base < Grape::API
      format :json

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        Rack::Response.new([{ error: e.message }.to_json], 400, 'Content-type' => 'text/error')
      end
      
      mount Api::DBpediaSparql
    end
  end
end
