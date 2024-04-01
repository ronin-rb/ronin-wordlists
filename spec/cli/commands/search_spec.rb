require 'spec_helper'
require 'ronin/wordlists/cli/commands/search'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Search do
  include_examples "man_page"

  describe "#initialize" do
    it "must initialize #categories to an empty Set" do
      expect(subject.categories).to eq(Set.new)
    end
  end

  describe "options" do
    context "when the '-c CATEGORY' option" do
      let(:category1) { 'dns' }
      let(:category2) { 'subdomains' }

      before do
        subject.option_parser.parse(
          ['-c', category1, '-c', category2]
        )
      end

      it "must append the category names to #categories" do
        expect(subject.categories).to eq(Set[category1, category2])
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

  let(:name3)       { 'tlds' }
  let(:url3)        { 'https://raw.githubusercontent.com/rbsec/dnscan/master/tlds.txt' }
  let(:summary3)    { 'List of common TLDs used by the dnscan util.' }
  let(:categories3) { %w[dns tlds] }

  let(:wordlist_index) do
    Ronin::Wordlists::CLI::WordlistIndex.new(
      {
        name1 => Ronin::Wordlists::CLI::WordlistIndex::Entry.new(
                   name1, url:        url1,
                          summary:    summary1,
                          categories: categories1
                 ),

        name2 => Ronin::Wordlists::CLI::WordlistIndex::Entry.new(
                   name2, url:        url2,
                          summary:    summary2,
                          categories: categories2
                 ),

        name3 => Ronin::Wordlists::CLI::WordlistIndex::Entry.new(
                   name3, url:        url3,
                          summary:    summary3,
                          categories: categories3
                 )
      }
    )
  end

  describe "#run" do
    before do
      allow(Ronin::Wordlists::CLI::WordlistIndex).to receive(:load).and_return(wordlist_index)
    end

    context "when no arguments are given" do
      it "must print all entries in the wordlist index" do
        expect {
          subject.run
        }.to output(
          [
            "[ #{name1} ]",
            '',
            "  * URL: #{url1}",
            "  * Categories: #{categories1.join(', ')}",
            "  * Summary: #{summary1}",
            '',
            "[ #{name2} ]",
            '',
            "  * URL: #{url2}",
            "  * Categories: #{categories2.join(', ')}",
            "  * Summary: #{summary2}",
            '',
            "[ #{name3} ]",
            '',
            "  * URL: #{url3}",
            "  * Categories: #{categories3.join(', ')}",
            "  * Summary: #{summary3}",
            $/
          ].join($/)
        ).to_stdout
      end
    end

    context "when the keyword argument is given" do
      let(:keyword) { 'subdomain' }

      it "must print the entries that include the given keyword" do
        expect {
          subject.run(keyword)
        }.to output(
          [
            "[ #{name2} ]",
            '',
            "  * URL: #{url2}",
            "  * Categories: #{categories2.join(', ')}",
            "  * Summary: #{summary2}",
            $/
          ].join($/)
        ).to_stdout
      end
    end

    context "when the category: keyword argument is given" do
      let(:categories) { Set['dns'] }

      before do
        subject.option_parser.parse(
          categories.map { |category|
            ['-c', category]
          }.flatten
        )
      end

      it "must print the entries who's #categories include the given categories: Set" do
        expect {
          subject.run
        }.to output(
          [
            "[ #{name2} ]",
            '',
            "  * URL: #{url2}",
            "  * Categories: #{categories2.join(', ')}",
            "  * Summary: #{summary2}",
            '',
            "[ #{name3} ]",
            '',
            "  * URL: #{url3}",
            "  * Categories: #{categories3.join(', ')}",
            "  * Summary: #{summary3}",
            $/
          ].join($/)
        ).to_stdout
      end
    end

    context "when both a keyword argument and categories: keyword argument are given" do
      let(:keyword)    { 'TLD' }
      let(:categories) { Set['dns'] }

      before do
        subject.option_parser.parse(
          categories.map { |category|
            ['-c', category]
          }.flatten
        )
      end

      it "must print the entries that contain the given keyword and who's #categories include the given categories: Set" do
        expect {
          subject.run(keyword)
        }.to output(
          [
            "[ #{name3} ]",
            '',
            "  * URL: #{url3}",
            "  * Categories: #{categories3.join(', ')}",
            "  * Summary: #{summary3}",
            $/
          ].join($/)
        ).to_stdout
      end
    end
  end

  describe "#search" do
    before do
      allow(Ronin::Wordlists::CLI::WordlistIndex).to receive(:load).and_return(wordlist_index)
    end

    context "when no arguments are given" do
      it "must return an Enumerator of all entries in the wordlist index" do
        expect(subject.search.to_a).to eq(wordlist_index.to_a)
      end
    end

    context "when the keyword argument is given" do
      let(:keyword) { 'subdomain' }

      it "must return an Enumerator of entries that include the given keyword" do
        expect(subject.search(keyword).to_a).to eq(
          wordlist_index.filter { |entry|
            entry.name.include?(keyword)    ||
            entry.summary.include?(keyword) ||
            entry.categories.include?(keyword)
          }
        )
      end
    end

    context "when the category: keyword argument is given" do
      let(:categories) { Set['dns', 'subdomains'] }

      it "must return an Enumerator of entries who's #categories include the given categories: Set" do
        expect(subject.search(categories: categories).to_a).to eq(
          wordlist_index.filter { |entry|
            categories.subset?(entry.categories)
          }
        )
      end
    end

    context "when both a keyword argument and categories: keyword argument are given" do
      let(:keyword)    { 'TLD' }
      let(:categories) { Set['dns'] }

      it "must return an Enumerator of entries that contain the given keyword and who's #categories include the given categories: Set" do
        expect(subject.search(keyword, categories: categories).to_a).to eq(
          wordlist_index.filter { |entry|
            categories.subset?(entry.categories) &&
            (
              entry.name.include?(keyword)    ||
              entry.summary.include?(keyword) ||
              entry.categories.include?(keyword)
            )
          }
        )
      end
    end
  end

  describe "#print_entry" do
    let(:name) { 'rockyou' }
    let(:url)  { 'https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt' }

    let(:summary)    { 'Common passwords list.' }
    let(:categories) { %w[passwords] }

    let(:entry) do
      Ronin::Wordlists::CLI::WordlistIndex::Entry.new(
        name, url:        url,
              summary:    summary,
              categories: categories
      )
    end

    it "must print the entry's #name, #url, #categories, and #summary" do
      expect {
        subject.print_entry(entry)
      }.to output(
        [
          "[ #{name} ]",
          '',
          "  * URL: #{url}",
          "  * Categories: #{categories.join(', ')}",
          "  * Summary: #{summary}",
          $/
        ].join($/)
      ).to_stdout
    end
  end
end
