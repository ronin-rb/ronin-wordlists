require 'spec_helper'
require 'ronin/wordlists/wordlist_dir'
require 'ronin/wordlists/exceptions'

describe Ronin::Wordlists::WordlistDir do
  subject { described_class.new(path) }

  let(:path) { File.expand_path(File.join(__dir__, '..', 'spec', 'fixtures', 'wordlists')) }

  describe "#initialize" do
    it "must initialize #path" do
      expect(subject.path).to eq(path)
    end
  end

  describe "#each" do
    context "if block is not given" do
      it "must return an Enumerator" do
        expect(subject.each).to be_kind_of(Enumerator)
      end
    end

    context "if block is given" do
      let(:wordlists_paths) { Dir["#{subject.path}/*"] }

      it "must must yield all wordlists" do
        yielded_values = []

        subject.each do |value|
          yielded_values << value
        end

        expect(yielded_values).to eq(wordlists_paths)
      end
    end
  end

  describe "#find" do
    let(:example_wrodlist_path) { File.join(path, "example_wordlist.txt") }

    context "if an exact file exist" do
      it "must return its path" do
        expect(subject.find("example_wordlist.txt")).to eq(example_wrodlist_path)
      end
    end

    context "if an exact file does not exist" do
      it "must search for the wordlist file by name" do
        expect(subject.find("example_wordlist")).to eq(example_wrodlist_path)
      end
    end
  end

  describe "#list" do
    let(:all_wordlists) { Dir.children(path) }

    context "if argument is not passed" do
      it "must list all wordlists in the wordlist directories" do
        expect(subject.list.sort).to eq(all_wordlists.sort)
      end
    end

    context "if argument is passed" do
      it "and file is found, it must return an array of wordlists filenames" do
        expect(subject.list("foo_wordlist")).to eq(["foo_wordlist.txt"])
      end

      it "but file is not found, it must return an empty array" do
        expect(subject.list("invalid_wordlist")).to eq([])
      end
    end
  end

  describe "#open" do
    context "if wordlist exist" do
      let(:example_wrodlist_path) { File.join(path, "example_wordlist.txt") }

      it "must call .open on Wordlist with path" do
        expect(Wordlist).to receive(:open).with(example_wrodlist_path)
        subject.open("example_wordlist")
      end
    end

    context "if wordlist does not exist" do
      let(:filename) { "foo_bar_baz" }

      it "must raise a WordlistNotFound error" do
        expect {
          subject.open(filename)
        }.to raise_error(Ronin::Wordlists::WordlistNotFound, "wordlist not found: #{filename.inspect}")
      end
    end
  end

  describe "#download" do
    context "for git url" do
      let(:url) { "https://github.com/Escape-Technologies/graphql-wordlist.git" }

      it "must download wordlist via WordlistRepo" do
        expect(Ronin::Wordlists::WordlistRepo).to receive(:download).with(url, subject.path)
        subject.download(url)
      end
    end

    context "for other urls" do
      let(:url) { "https://raw.githubusercontent.com/rbsec/dnscan/master/tlds.txt" }

      it "must download wordlist via WordlistFile" do
        expect(Ronin::Wordlists::WordlistFile).to receive(:download).with(url, subject.path)
        subject.download(url)
      end
    end
  end

  describe "#delete" do
    context "if wordlist exists" do
      let(:example_wrodlist_path) { File.join(path, "example_wordlist.txt") }

      it "must delete wordlist file" do
        expect(File).to receive(:unlink).with(example_wrodlist_path)
        subject.delete("example_wordlist")
      end
    end

    context "if wordlist does not exist" do
      let(:name) { "invalid_name" }

      it "must raise an error" do
        expect {
          subject.delete(name)
        }.to raise_error(ArgumentError, "unknown wordlist: #{name.inspect}")
      end
    end
  end
end
