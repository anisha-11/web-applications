require 'sinatra/base'
require 'sinatra/reloader'

class Application < Sinatra::Base
  get "/names" do 
    return "Julia, Mary, Karim"
  end 

  # This allows the app code to refresh 
  # without having to restart the server.
  configure :development do
    register Sinatra::Reloader
  end
end