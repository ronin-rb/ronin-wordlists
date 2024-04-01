require 'spec_helper'
require 'ronin/wordlists/cli/commands/download'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Download do
  include_examples "man_page"

  let(:url) { 'http://example.com/wordlist.txt' }

  describe '#run' do
    context 'when the url is provided' do
      it 'must call download with the URL' do
        expect(subject).to receive(:download).with(url)

        subject.run(url)
      end
    end

    context 'when the name is provided' do
      let(:name) { 'download_wordlist' }

      context "and it exists in the data/wordlists.yml file" do
        before do
          allow(Ronin::Wordlists::CLI::WordlistIndex).to receive(:load).and_return(
            Ronin::Wordlists::CLI::WordlistIndex.new(
              {
                name => Ronin::Wordlists::CLI::WordlistIndex::Entry.new(
                          name, url:        url,
                                summary:    'A test wordlist',
                                categories: %w[test]
                        )
              }
            )
          )
        end

        it 'must look up the URL from the data/wordlists.yml and calls download' do
          expect(subject).to receive(:download).with(url)

          subject.run(name)
        end
      end

      context 'when the name is unknown' do
        it 'must print an error and exit' do
          expect {
            subject.run('unknown_wordlist')
          }.to output(/unknown wordlist/).to_stderr.and raise_error(SystemExit)
        end
      end
    end
  end

  describe '#download' do
    context 'when the download is successful' do
      it 'must log a success message' do
        allow(subject.wordlist_dir).to receive(:download).with(url).and_return(double('DownloadedWordlist', name: 'test_wordlist'))

        expect {
          subject.download(url)
        }.to output(/Wordlist test_wordlist downloaded/).to_stdout
      end
    end

    context 'when the download fails' do
      it 'must log error massage and exit' do
        allow(subject.wordlist_dir).to receive(:download).with(url).and_raise(Ronin::Wordlists::DownloadFailed.new('Download failed'))

        expect {
          subject.download(url)
        }.to output(/Download failed/).to_stderr.and raise_error(SystemExit)
      end
    end
  end
end
