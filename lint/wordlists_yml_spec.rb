require 'rspec'
require 'yaml'
require 'uri'

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

      describe ":url" do
        it "must be a valid http:// or https:// URL" do
          uri = URI(attributes[:url])

          expect(uri).to be_kind_of(URI::HTTP).or(be_kind_of(URI::HTTPS))
          expect(uri.host).to_not be(nil), "URI does not have a host name"
          expect(uri.host).to_not be_empty, "URI does not have a host name"
          expect(uri.port).to_not be(nil), "URI does not have a port number"
          expect(uri.path).to_not be(nil), "URI does not have a path"
          expect(uri.path).to_not be_empty, "URI does not have a path"
        end
      end

      it "must have :categories" do
        expect(attributes[:categories]).to be_kind_of(Array)
        expect(attributes[:categories]).to_not be_empty
        expect(attributes[:categories]).to all(be_kind_of(String))
      end

      describe ":categories" do
        it "must contain lowercase words" do
          expect(attributes[:categories]).to all(match(/\A[a-z][a-z0-9_-]+\z/))
        end
      end

      it "must have a :summary" do
        expect(attributes[:summary]).to be_kind_of(String)
        expect(attributes[:summary]).to_not be_empty
      end

      describe ":summary" do
        it "must end with a period" do
          expect(attributes[:summary]).to end_with('.')
        end
      end
    end
  end
end
