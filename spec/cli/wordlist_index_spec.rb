require 'spec_helper'
require 'ronin/wordlists/cli/wordlist_index'

describe Ronin::Wordlists::CLI::WordlistIndex do
  describe described_class::Entry do
    let(:name) { 'rockyou' }
    let(:url)  { 'https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt' }

    let(:summary)    { 'Common passwords list.' }
    let(:categories) { %w[passwords] }

    subject do
      described_class.new(name, url:        url,
                                summary:    summary,
                                categories: categories)
    end

    describe "#initialize" do
      it "must set #name" do
        expect(subject.name).to eq(name)
      end

      it "must set #url" do
        expect(subject.url).to eq(url)
      end

      it "must set #summary" do
        expect(subject.summary).to eq(summary)
      end

      context "when the categories: keyword argument is given" do
        it "must set #categories as the Set of the given categories:" do
          expect(subject.categories).to eq(Set.new(categories))
        end
      end

      context "when the categories: keyword argument is not given" do
        subject do
          described_class.new(name, url:     url,
                                    summary: summary)
        end

        it "must default #categories to an empty Set" do
          expect(subject.categories).to eq(Set.new)
        end
      end
    end
  end

  describe described_class::InvalidSchema do
    it "must inherit from Ronin::Wordlists::Exception" do
      expect(described_class).to be < Ronin::Wordlists::Exception
    end
  end

  describe "PATH" do
    it "must point to 'data/wordlists.yml'" do
      expect(described_class::PATH).to eq(File.join(Ronin::Wordlists::ROOT,'data','wordlists.yml'))
    end
  end

  describe ".load" do
    subject { described_class }

    let(:fixtures_dir) { File.join(__dir__,'fixtures') }

    let(:path) { File.join(fixtures_dir,'wordlists.yml') }

    it "must return a new #{described_class} containing the parsed #{described_class::Entry} objects" do
      index = subject.load(path)

      expect(index).to be_kind_of(described_class)
      expect(index.entries.size).to be(2)

      expect(index.entries['rockyou']).to be_kind_of(described_class::Entry)
      expect(index.entries['rockyou'].name).to eq('rockyou')
      expect(index.entries['rockyou'].url).to eq('https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt')
      expect(index.entries['rockyou'].summary).to eq('Common passwords list.')
      expect(index.entries['rockyou'].categories).to eq(Set['passwords'])

      expect(index.entries['subdomains-1000']).to be_kind_of(described_class::Entry)
      expect(index.entries['subdomains-1000'].name).to eq('subdomains-1000')
      expect(index.entries['subdomains-1000'].url).to eq('https:/raw.githubusercontent./com/rbsec/dnscan/master/subdomains-1000.txt')
      expect(index.entries['subdomains-1000'].summary).to eq('Top 1000 most common subdomain names used by the dnscan util.')
      expect(index.entries['subdomains-1000'].categories).to eq(Set['dns', 'subdomains'])
    end

    context "when the wordlist index file does not contain a Hash" do
      let(:path) { File.join(fixtures_dir,'wordlists_without_a_hash.yml') }

      it do
        expect {
          subject.load(path)
        }.to raise_error(described_class::InvalidSchema,"wordlist index file does not contain a Hash: #{path.inspect}")
      end
    end

    context "when the wordlist index file contains an entry that is missing a url:" do
      let(:path) { File.join(fixtures_dir,'wordlists_missing_a_url.yml') }
      let(:name) { 'bad' }

      it do
        expect {
          subject.load(path)
        }.to raise_error(described_class::InvalidSchema,"wordlist index entry does not have a URL: #{name.inspect}")
      end
    end

    context "when the wordlist index file contains an entry that is missing a summary:" do
      let(:path) { File.join(fixtures_dir,'wordlists_missing_a_summary.yml') }
      let(:name) { 'bad' }

      it do
        expect {
          subject.load(path)
        }.to raise_error(described_class::InvalidSchema,"wordlist index entry does not have a summary: #{name.inspect}")
      end
    end
  end

  let(:name1)       { 'rockyou' }
  let(:url1)        { 'https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt' }
  let(:summary1)    { 'Common passwords list.' }
  let(:categories1) { %w[passwords] }

  let(:name2)       { 'subdomains-1000' }
  let(:url2)        { 'https:/raw.githubusercontent./com/rbsec/dnscan/master/subdomains-1000.txt' }
  let(:summary2)    { 'Top 1000 most common subdomain names used by the dnscan util.' }
  let(:categories2) { %w[dns subdomains] }

  let(:entries) do
    {
      name1 => described_class::Entry.new(
                 name1, url:        url1,
                        summary:    summary1,
                        categories: categories1
               ),

      name2 => described_class::Entry.new(
                 name2, url:        url2,
                        summary:    summary2,
                        categories: categories2
               )
    }
  end

  subject { described_class.new(entries) }

  it "must include Enumerable" do
    expect(described_class).to include(Enumerable)
  end

  describe "#initialize" do
    it "must set #entries" do
      expect(subject.entries).to be(entries)
    end
  end

  describe "#[]" do
    context "when there is an entry with the same name" do
      let(:name) { name1 }

      it "must return the #{described_class::Entry} for the given name" do
        expect(subject[name]).to be_kind_of(described_class::Entry)
        expect(subject[name].name).to eq(name)
      end
    end

    context "when there is no entry with the matching name" do
      let(:name) { 'does_not_exist' }

      it "must return nil" do
        expect(subject[name]).to be(nil)
      end
    end
  end

  describe "#each" do
    context "when given a block" do
      it "must yield every #{described_class::Entry} value" do
        expect { |b|
          subject.each(&b)
        }.to yield_successive_args(*entries.values)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator which yields every #{described_class::Entry} value" do
        expect(subject.each.to_a).to eq(entries.values)
      end
    end
  end
end
