require 'spec_helper'
require 'ronin/wordlists/cli/wordlist_dir_option'
require 'ronin/wordlists/cli/command'

RSpec.describe Ronin::Wordlists::CLI::WordlistDirOption do
  class TestWordlistDirOptionCommand < Ronin::Wordlists::CLI::Command
    include Ronin::Wordlists::CLI::WordlistDirOption
  end

  let(:command_class) { TestWordlistDirOptionCommand }

  describe '.included' do
    subject { command_class }

    it 'adds the --wordlist-dir option to the command' do
      expect(subject.options).to include(:wordlist_dir)
    end
  end

  describe '#wordlist_dir' do
    subject { command_class.new }

    context 'when --wordlist-dir is specified' do
      before do
        subject.options[:wordlist_dir] = '/path/to/dir'
      end

      it 'returns a WordlistDir with the specified directory' do
        expect(subject.wordlist_dir).to be_a(Ronin::Wordlists::WordlistDir)
        expect(subject.wordlist_dir.path).to eq('/path/to/dir')
      end
    end

    context 'when --wordlist-dir is not specified' do
      it 'returns a default CacheDir' do
        expect(subject.wordlist_dir).to be_a(Ronin::Wordlists::CacheDir)
      end
    end
  end
end
