require 'spec_helper'
require 'ronin/wordlists/cli/commands/remove'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Remove do
  include_examples "man_page"

  let(:wordlist_dir) { double('WordlistDir') }

  describe '#run' do
    context 'when the wordlist exists' do
      let(:wordlist_name) { 'wordlist' }

      before do
        allow(subject).to receive(:wordlist_dir).and_return(wordlist_dir)
      end

      it 'must remove it from cache directory' do
        expect(wordlist_dir).to receive(:remove).with(wordlist_name)
        subject.run(wordlist_name)
      end
    end

    context 'when the wordlist does not exist' do
      let(:wordlist_name) { 'not_existing_wordlist'}

      it 'must print an error message and exit' do
        expect {
          subject.run(wordlist_name)
        }.to output("no such wordlist #{wordlist_name}").to_stderr
      end
    end
  end
end
