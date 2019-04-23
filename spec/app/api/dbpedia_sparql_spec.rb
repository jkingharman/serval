# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'api dbpedia_sparql' do
  include Rack::Test::Methods

  let(:app) { Serval::Api::Base }

  let(:jonze_results) do
    {
      films:
      [
        'Three_Kings_(1999_film)',
        'Torrance_Rises',
        'Higglety_Pigglety_Pop!_or_There_Must_Be_More_to_Life',
        'Amarillo_by_Morning_(film)',
        'Tell_Them_Anything_You_Want:_A_Portrait_of_Maurice_Sendak'
      ]
    }
  end

  let(:big_lebowski_results) do
    {
      actors:
      %w[
        Jeff_Bridges
        Steve_Buscemi
        David_Huddleston
        Julianne_Moore
        John_Goodman
        John_Turturro
      ]
    }
  end

  describe 'GET root' do
    it 'requires a film or actor' do
      get '/'
      expect(last_response.status).to eq 400
      expect(response_body.key?('error')).to be true
    end

    it 'accepts only one film or actor per request' do
      get '/', stringify_keys(actor: 'Spike_Jonze', film: 'Three_Kings')

      expect(last_response.status).to eq 400
      expect(response_body.key?('error')).to be true
    end

    it 'requires a valid format for actors' do
      invalids = ['', 'SPIKE_JONZE', 'Spikee.Jonze']

      invalids.each do |invalid|
        get '/', stringify_keys(actor: invalid)
        expect(last_response.status).to eq 400
        expect(response_body.key?('error')).to be true
      end
    end

    it 'requires a valid format for films' do
      invalids = %w[city_of_god '' _City_Of_God]

      invalids.each do |invalid|
        get '/', stringify_keys(film: invalid)
        expect(last_response.status).to eq 400
        expect(response_body.key?('error')).to be true
      end
    end

    it 'gets films featuring the actor' do
      get '/', stringify_keys(actor: 'Spike_Jonze')
      expect(last_response.status).to eq 200
      expect(response_body).to eq(stringify_keys(jonze_results))
    end

    it 'gets cached films if the actor has been seen' do
      expect(SPARQL::Client).not_to receive(:new)
      get '/', stringify_keys(actor: 'Spike_Jonze')

      expect(last_response.status).to eq 200
      expect(response_body).to eq(stringify_keys(jonze_results))
    end

    it 'gets actors starring in film' do
      get '/', stringify_keys(film: 'The_Big_Lebowski')
      expect(last_response.status).to eq 200
      expect(response_body).to eq(stringify_keys(big_lebowski_results))
    end

    it 'gets cached actors if the film has been seen' do
      expect(SPARQL::Client).not_to receive(:new)
      get '/', stringify_keys(film: 'The_Big_Lebowski')

      expect(last_response.status).to eq 200
      expect(response_body).to eq(stringify_keys(big_lebowski_results))
    end
  end
end
