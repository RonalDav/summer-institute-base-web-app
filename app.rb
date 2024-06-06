# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

# App is the main application where all your logic & routing will go
class App < Sinatra::Base
  set :erb, escape_html: true
  enable :sessions

  attr_reader :logger

  def initialize
    super
    @logger = Logger.new('log/app.log')
  end

  def title
    'Summer Instititue Starter App'
  end

  def projects_root
      "#{__dir__}/projects"
  end
  
  get '/examples' do
    erb(:examples)
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Summer Institute 2024' }
    erb(:index)
  end
  
  get '/projects/new' do
      erb(:new_project)
    #   "Hello World"
  end
  
  #first post request
  post '/projects/new' do
      "Hello World"
      # make dir based on name given in form
      name = params[:name].downcase.gsub(' ','_')
      FileUtils.mkdir_p("#{projects_root}/#{name}")
      
      session[:flash] = {info: "Created new project #{params[:name]}" }
      
      redirect(url("/projects/#{name}"))
  end
  
end
