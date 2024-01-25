require 'spec_helper'
require 'ronin/wordlists/cli/wordlist_option'
require 'ronin/wordlists/cli/command'

RSpec.describe Ronin::Wordlists::CLI::WordlistOption do
  class TestWordlistOptionCommand < Ronin::Wordlists::CLI::Command
    include Ronin::Wordlists::CLI::WordlistOption
  end

  let(:command_class) { TestWordlistOptionCommand }

  describe '.included' do
    subject { command_class }

    it 'adds the --wordlist option to the command' do
      expect(subject.options).to include(:wordlist)
    end
  end
end
