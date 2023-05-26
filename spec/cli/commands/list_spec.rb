require 'spec_helper'
require 'ronin/wordlists/cli/commands/list'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::List do
  include_examples "man_page"
end
