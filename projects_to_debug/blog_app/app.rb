require 'sinatra/base'
require "sinatra/reloader"
require './lib/post'
require './lib/post_manager'

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/post.rb'
    also_reload 'lib/post_manager.rb'
  end

  before do
    @post_manager = PostManager.instance
  end

  get '/' do
    @posts = @post_manager.all_posts

    return erb(:index)
  end

  # get posts for a given tag
  get '/tag/:tag' do
    @posts = @post_manager.all_posts_by_tag(params[:tag])

    return erb(:index)
  end

  # create new post
  post '/albums' do
    # if_invalid_post?
    # status 400 
    # return ''

    new_post = Post.new(params[:title], params[:content], params[:tags].split(','))
    @post_manager.add_post(new_post)

    return redirect('/')
  end

  def if_invalid_post? 
    variable = /^((https?|ftp|file):\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
    return (params[:title] == variable || params[:content == variable || params[:tags]] == variable)
  end 
end
