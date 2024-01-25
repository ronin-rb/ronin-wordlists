require 'spec_helper'
require 'ronin/wordlists/cli/wordlist_option'
require 'ronin/wordlists/cli/command'

RSpec.describe Ronin::Wordlists::CLI::WordlistOption do
  class WordlistOptionCommandMock < Ronin::Wordlists::CLI::Command
    include Ronin::Wordlists::CLI::WordlistOption
  end

  describe '.included' do
    subject { WordlistOptionCommandMock }

    it 'adds the --wordlist option to the command' do
      expect(subject.options).to include(:wordlist)
    end
  end
end
