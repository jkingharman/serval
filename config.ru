# frozen_string_literal: true

require 'bundler/setup'
Bundler.require

# Add lib to paths for ease.
$LOAD_PATH << './app'

require 'serval'
# require 'config'

run Serval::Api::Base
