require 'spec_helper'
require 'ronin/wordlists/cli/commands/purge'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Purge do
  include_examples "man_page"
end
