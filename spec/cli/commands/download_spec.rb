require 'spec_helper'
require 'ronin/wordlists/cli/commands/download'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Download do
  include_examples "man_page"
end
