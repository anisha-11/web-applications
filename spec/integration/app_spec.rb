require "spec_helper"
require "rack/test"
require_relative "../../app"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /sort-names" do
    it 'returns 200 OK' do
      
      response = post('/sort-names', names: "Joe, Alice, Zoe, Julia, Keiran")

      expect(response.status).to eq(200)
      expect(response.body).to eq "Alice, Joe, Julia, Keiran, Zoe"
    end

    it 'returns 200 OK' do
      
      response = post('/sort-names', names: "Chris, Anisha, Zoe, Julia, Keiran")

      expect(response.status).to eq(200)
      expect(response.body).to eq "Anisha, Chris, Julia, Keiran, Zoe"
    end
  end
end