require 'spec_helper'
require 'ronin/wordlists/cli/commands/list'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::List do
  include_examples "man_page"

  describe '#run' do
    context 'with given name' do
      let(:name)      { 'list' }
      let(:wordlists) { ['list1', 'list2'] }

      it 'must list wordlists matching the specified name' do
        expect(subject.wordlist_dir).to receive(:list).with(name).and_return(wordlists)
        expect {
          subject.run(name)
        }.to output(
          [
            "  list1",
            "  list2",
            ""
          ].join($/)
        ).to_stdout
      end
    end

    context 'witout given name' do
      let(:wordlists) { ['wordlist1', 'wordlist2', 'wordlist3'] }

      it 'must list all wordlists' do
        expect(subject.wordlist_dir).to receive(:list).with(no_args).and_return(wordlists)
        expect {
          subject.run
        }.to output(
          [
            "  wordlist1",
            "  wordlist2",
            "  wordlist3",
            ""
          ].join($/)
        ).to_stdout
      end
    end
  end
end
