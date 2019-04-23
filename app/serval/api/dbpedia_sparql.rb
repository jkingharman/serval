# frozen_string_literal: true

module Serval
  module Api
    class DBpediaSparql < Grape::API

      params do
        # TODO: Add regex.
        optional :film, type: String, allow_blank: false
        optional :actor, type: String, allow_blank: false
        exactly_one_of :film, :actor
      end
      get '/' do

      end
    end
  end
end
