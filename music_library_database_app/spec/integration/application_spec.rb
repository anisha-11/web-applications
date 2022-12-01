require "spec_helper"
require "rack/test"
require_relative '../../app'

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "GET /albums/new" do 
    it 'returns the form to add a new album' do 
      response = get('/albums/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/albums">')
      expect(response.body).to include('<input type="text" name="title" />')
      expect(response.body).to include('<input type="text" name="release_year" />')
      expect(response.body).to include('<input type="text" name="artist_id" />')
    end 
  end 

  context "POST /albums" do
    it 'should validate album parameters' do 
      response = post('/albums', invalid_artist_title: 'Voyage', another_invalid_thing: 123)

      expect(response.status).to eq(400)
    end 

    it 'returns 200 OK' do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)
      
      expect(response.status).to eq(200)
      response = get('/albums/13')
      expect(response.status).to eq(200)
      expect(response.body).to include("Voyage")
    end 
  end

  context "GET /artists" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/artists')
      expected_response = 'Pixies, ABBA, Taylor Swift, Nina Simone, Kiasmos'

      expect(response.status).to eq(200)
      # expect(response.body).to eq(expected_response)
      expect(response.body).to include('<h1>Artists:</h1>')
    end
  end

  context "GET /artists/new" do 
    it 'return html form page to get a new artist' do 
      response = get('/artists/new')

      expect(response.status).to eq(200)
      expect(response.body).to include('<form method="POST" action="/artists">')
      expect(response.body).to include('<input type="text" name="name" />')
      expect(response.body).to include('<input type="text" name="genre" />')
    end 
  end 

  context "POST /artists" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = post('/artists', name: "Giveon", genre: "RnB")

      expect(response.status).to eq(200)
      expect(response.body).to eq('')

      response = get('/artists')

      expect(response.status).to eq(200)
      expect(response.body).to include 'Giveon'
    end
  end

  context "GET /albums/id" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Artist: Pixies')
    end
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums/3')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Waterloo</h1>')
      expect(response.body).to include('Release year: 1974')
    end
  end

  context "GET /albums" do
    it 'returns 200 OK' do
      # Assuming the post with id 1 exists.
      response = get('/albums')
      # expected_response = "Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
      expect(response.status).to eq(200)
      # expect(response.body).to eq(expected_response)
      expect(response.body).to include('Title: Surfer Rosa')
      expect(response.body).to include('Released: 202')
      expect(response.body).to include('Title: Ring Ring')
    end
  end

  context "GET /artists/:id" do 
    it 'returns 200 OK' do 
      response = get("/artists/2")

      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>ABBA</h1>')
      expect(response.body).to include('Genre: Pop')
    end 
  end
end
