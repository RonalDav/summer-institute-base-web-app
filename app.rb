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
    #   Pathnames.new"#{__dir__}/projects" 
      "#{__dir__}/projects"
  end
  
  def sanitize_project_name(name)
      name.downcase.gsub(' ','_')
  end
  
  get '/examples' do
    erb(:examples)
  end

  get '/' do
    logger.info('requsting the index')
    @flash = session.delete(:flash) || { info: 'Summer Institute 2024' }
    erb(:index)
  end
  
  get '/projects/:name' do
      # a very sinatra thing to get the variable
      if params[:name] == 'new' 
          erb(:new_project)
      else
          proj_name = sanitize_project_name(params[:name])
          # make sure we're going somewhere that exists
          @directory = Pathname.new("#{projects_root}/#{proj_name}")
        #   @directory = Pathname.new("#{projects_root}/#{params[:name]}")
          
          if(@directory.directory? && @directory.readable?)
              erb(:show_project)
          else
              session[:flash] = { danger: "Project '#{params[:name]} does not exist!"}
              redirect(url('/'))
              #redirect flash message
          end
      end
  end
  
  #first post request
  post '/projects/new' do
      "Hello World"
      # make dir based on name given in form
    #   name = 
      name = sanitize_project_name(params[:name])
      FileUtils.mkdir_p("#{projects_root}/#{name}")
      
      session[:flash] = {info: "Created new project #{params[:name]}" }
      
      redirect(url("/projects/#{name}"))
  end
  
end
