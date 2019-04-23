# frozen_string_literal: true

require 'bundler'
Bundler.require(:default)

$LOAD_PATH << './app'

require 'serval'

run Serval::Api::Base
