require 'sinatra/base'
require "sinatra/config_file"
require 'soda'
require 'chronic'

class WasMyCarTowed < Sinatra::Base
  # Config file
  register Sinatra::ConfigFile
  config_file 'config.yml'

  # The view ids of the towed and relocated datasets
  # http://data.cityofchicago.org/
  set :towed_view_id, 'ygr5-vcbg'
  set :relocated_view_id, '5k2z-suxx'

  # Initialize the soda client
  # App token comes either from Heroku's environment variables of the config file
  app_token = ENV['APP_TOKEN'] || settings.app_token
  client = SODA::Client.new domain: "data.cityofchicago.org", app_token: app_token

  # Index
  get '/' do
    erb :index
  end

  # Search
  post '/' do
    @vehicle = nil
    @plate_number = params[:plate].gsub(/\s+/, "").upcase
    
    # Sanity check
    if @plate_number.empty?
      redirect "/"
    end

    # See if the vehicle was towed
    @vehicle = client.get(settings.towed_view_id, {'$limit' => 1, plate: @plate_number}).first

    # If it wasn't towed, see if it was relocated
    if not @vehicle
      @relocated = true
      @vehicle = client.get(settings.relocated_view_id, {'$limit' => 1, plate: @plate_number}).first
    end

    erb :results
  end
end