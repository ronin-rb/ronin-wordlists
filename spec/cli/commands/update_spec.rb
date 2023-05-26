require 'spec_helper'
require 'ronin/wordlists/cli/commands/update'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Update do
  include_examples "man_page"
end
