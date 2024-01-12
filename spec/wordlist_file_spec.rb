require 'spec_helper'
require 'ronin/wordlists/wordlist_file'
require 'ronin/core/system'

require_relative 'wordlist_metadata_examples'

describe Ronin::Wordlists::WordlistFile do
  subject { described_class.new(path, url: url) }

  let(:fixtures_dir) { File.expand_path(File.join(__dir__, '..', 'spec', 'fixtures')) }

  let(:path) { File.join(fixtures_dir, 'wordlists') }
  let(:url)  { "https://www.example.com/wordlist" }

  describe "#initialzie" do
    subject { described_class.new(path) }

    it "must initialize #path and #name" do
      expect(subject.path).to eq(path)
    end

    it "must default #name to the basename of #path" do
      expect(subject.name).to eq(File.basename(path))
    end

    include_context "WordlistMetadata#initialize"

    context "when the url: keyword is given" do
      subject { described_class.new(path, url: url) }

      it "must initialize #path, #name, and #url" do
        expect(subject.path).to eq(path)
        expect(subject.name).to eq(File.basename(path))
        expect(subject.url).to eq(url)
      end
    end
  end

  describe ".download" do
    context "when the wordlist file is successfully downloaded" do
      let(:download_result) { described_class.download("valid.com") }

      before do
        allow(Ronin::Core::System).to receive(:download).and_return("/some/path")
      end

      it "must return new #{described_class}" do
        expect(download_result).to be_kind_of(described_class)
        expect(download_result.path).to eq("/some/path")
        expect(download_result.url).to eq("valid.com")
      end
    end

    context "but the wordlist file could not be downloaded" do
      before do
        allow(Ronin::Core::System).to receive(:download).and_raise(Ronin::Wordlists::DownloadFailed, "error message")
      end

      it "must raise a DownloadFailed error" do
        expect {
          described_class.download("invalid.com")
        }.to raise_error(Ronin::Wordlists::DownloadFailed, "error message")
      end
    end
  end

  describe "#type" do
    it "must return :file" do
      expect(subject.type).to eq(:file)
    end
  end

  describe "#filename" do
    it "must return wordlist file path's basename" do
      expect(subject.filename).to eq("wordlists")
    end
  end

  describe "#update" do
    context "when #url is not nil" do
      it "must download wordlist from url" do
        expect(described_class).to receive(:download).with(subject.url, subject.path)

        subject.update
      end
    end
  end

  describe "#delete" do
    it "must delete the wordlist file" do
      expect(File).to receive(:unlink).with(subject.path)

      subject.delete
    end
  end

  describe "#to_s" do
    it "must return wordlist file's path as a String" do
      expect(subject.to_s).to eq(path)
    end
  end
end
