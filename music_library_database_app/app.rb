# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative 'lib/database_connection'
require_relative 'lib/album_repository'
require_relative 'lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do 
    repo = AlbumRepository.new 
    @albums = repo.all
    return erb(:albums)
  end

  post '/albums' do
    if invalid_request_parameters?
        status 400
        return ''
    end 

    repo = AlbumRepository.new 
    new_albums = Album.new 
    new_albums.title = params[:title]
    new_albums.release_year = params[:release_year]
    new_albums.artist_id = params[:artist_id]

    repo.create(new_albums)
    return ''
  end

  get '/artists' do
    repo = ArtistRepository.new

    @artists = repo.all

    return erb(:artists)
  end

  post '/artists' do
    new_artist = Artist.new
    repo = ArtistRepository.new
    new_artist.name = params[:name]
    new_artist.genre = params[:genre]

    repo.create(new_artist)

    return ''
  end

  get '/albums/new' do 
    return erb(:new_albums)
  end 

  get '/albums/:id' do
    @album_id = params[:id]
    repo = AlbumRepository.new
    repo2 = ArtistRepository.new
    album = repo.find(@album_id)
    @title = album.title
    @release_year = album.release_year
    @artist = repo2.find(album.artist_id).name
    return erb(:albums)
  end

  get '/artists/new' do 
    return erb(:new_artist)
  end 

  get '/artists/:id' do 
    @artist_id = params[:id]
    repo = ArtistRepository.new
    @artist = repo.find(@artist_id)

    return erb(:artist_id)
  end
  
  def invalid_request_parameters?
    return (
      params[:title] == nil ||
      params[:release_year] == nil ||
      params[:artist_id] == nil)
  end 
end