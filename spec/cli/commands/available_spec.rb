require 'spec_helper'
require 'ronin/wordlists/cli/commands/available'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Available do
  include_examples "man_page"
end
