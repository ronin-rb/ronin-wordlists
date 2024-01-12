require 'spec_helper'
require 'yaml'

describe "data/wordlists.yml" do
  wordlists = YAML.load_file(File.join(__dir__,'..','data','wordlists.yml'))

  subject { wordlists }

  it "must contain a Hash" do
    expect(subject).to be_kind_of(Hash)
    expect(subject).to_not be_empty
  end

  wordlists.each do |name,attributes|
    describe(name) do
      let(:name) { name }
      let(:attributes) { attributes }

      it "must have a valid name" do
        expect(name).to match(/\A[A-Za-z0-9]+(?:[._-][A-Za-z0-9]+)*\z/)
      end

      it "must contain a Hash of attributes" do
        expect(attributes).to be_kind_of(Hash)
      end

      it "must use Symbols for it's attribute names" do
        expect(attributes.keys).to all(be_kind_of(Symbol))
      end

      it "must have a valid :url" do
        expect(attributes[:url]).to match(/\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/)
      end

      it "must have :categories" do
        expect(attributes[:categories]).to be_kind_of(Array)
        expect(attributes[:categories]).to_not be_empty
        expect(attributes[:categories]).to all(be_kind_of(String))
      end

      it "all :categories must be lowercase words" do
        expect(attributes[:categories]).to all(match(/\A[a-z][a-z0-9_-]+\z/))
      end

      it "must have a :summary" do
        expect(attributes[:summary]).to be_kind_of(String)
        expect(attributes[:summary]).to_not be_empty
        expect(attributes[:summary]).to end_with('.')
      end
    end
  end
end
