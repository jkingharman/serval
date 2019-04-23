# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'api base' do
  include Rack::Test::Methods

  let(:app) { Serval::Api::Base }

  it 'rescues from errors' do
    allow(Serval::Services::Sparql).to receive(:new) { raise 'error' }

    get '/', stringify_keys(actor: 'Spike_Jonze')
    expect(last_response.status).to eq 500
    expect(response_body).to eq('error' => 'Internal server error')
  end
end
