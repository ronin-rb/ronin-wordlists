require 'spec_helper'
require 'ronin/wordlists/cli/commands/download'
require 'ronin/wordlists/root'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Download do
  include_examples "man_page"

  let(:url)         { 'http://example.com/wordlist.txt' }
  let(:yaml_result) { { 'download_wordlist' => { url: url } } }

  describe '#run' do
    subject { Ronin::Wordlists::CLI::Commands::Download.new }

    context 'when the url is provided' do
      it 'must call download with the URL' do
        expect(subject).to receive(:download).with(url)

        subject.run(url)
      end
    end

    context 'when the name is provided' do
      let(:name) { 'download_wordlist' }

      context "and exist in wordlist" do
        before do
          allow(YAML).to receive(:load_file).and_return(yaml_result)
        end

        it 'must look up the URL from the wordlists and calls download' do
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
