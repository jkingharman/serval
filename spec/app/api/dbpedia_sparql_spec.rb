# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'api dbpedia_sparql' do
  include Rack::Test::Methods

  let(:app) { Serval::Api::Base }

  describe 'GET root' do
    it 'requires a film or actor param' do
      get '/'
      expect(last_response.status).to eq 400
      expect(response_body.key?('error')).to be true
    end

    it 'requires a film or actor param to not be blank' do
      get '/', stringify_keys(actor: '')
      expect(last_response.status).to eq 400
      expect(response_body.key?('error')).to be true
    end

    it 'accepts only one film or actor param per request' do
      get '/', stringify_keys(actor: 'Spike Jonze', film: 'Three Kings')

      expect(last_response.status).to eq 400
      expect(response_body.key?('error')).to be true
    end

  end
end
