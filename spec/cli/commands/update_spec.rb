require 'spec_helper'
require 'ronin/wordlists/cli/commands/update'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Update do
  include_examples "man_page"

  let(:cache_dir)     { instance_double('CacheDir') }
  let(:wordlist)      { instance_double('WordlistFile', name: wordlist_name, url: 'http://example.com') }
  let(:wordlist_name) { 'wordlist' }

  describe '#run' do
    before do
      allow(Ronin::Wordlists::CacheDir).to receive(:new).and_return(cache_dir)
    end

    context 'when wordlist name is provided' do
      it 'must update the specified wordlist' do
        allow(cache_dir).to receive(:[]).with(wordlist_name).and_return(wordlist)
        expect(subject).to receive(:update).with(wordlist)

        subject.run(wordlist_name)
      end

      context 'when the wordlist does not exist' do
        let(:wordlist_name) { 'not_existing_wordlist' }

        it 'must print an error and exit' do
          allow(cache_dir).to receive(:[]).with(wordlist_name).and_raise(Ronin::Wordlists::WordlistNotFound)

          expect {
            subject.run(wordlist_name)
          }.to output(/update: no such wordlist: #{wordlist_name}/).to_stderr.and raise_error(SystemExit)
        end
      end
    end

    context 'when wordlist name not provided' do
      it 'must update all wordlists' do
        expect(cache_dir).to receive(:each).and_yield(wordlist)
        expect(subject).to receive(:update).with(wordlist)

        subject.run
      end
    end
  end

  describe '#update' do
    it 'must log the update process and update wordlist when the update succeed' do
      expect(wordlist).to receive(:update)
      expect {
        subject.update(wordlist)
      }.to output(/Updating wordlist #{wordlist.name} from #{wordlist.url} .../).to_stdout
    end

    context 'when the update fails' do
      it 'must log an error message' do
        expect(wordlist).to receive(:update).and_raise(Ronin::Wordlists::DownloadFailed.new('Download failed'))
        expect {
          subject.update(wordlist)
        }.to output(/Download failed/).to_stderr
      end
    end
  end
end
