require 'sinatra/base'
require "sinatra/config_file"
require 'windy'
require 'chronic'

class WasMyCarTowed < Sinatra::Base
  # Config file
  register Sinatra::ConfigFile
  config_file 'config.yml'

  # The view ids of the towed and relocated datasets
  # http://data.cityofchicago.org/
  set :towed_view_id, 'ygr5-vcbg'
  set :relocated_view_id, '5k2z-suxx'

  # Add the app_token to Windy
  # either from Heroku's environment variables of the config file
  Windy.app_token = ENV['APP_TOKEN'] || settings.app_token

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
    towed_view = Windy.views.find_by_id(settings.towed_view_id)
    towed_vehicles = towed_view.rows
    @vehicle = towed_vehicles.find_by_plate(@plate_number)

    # If it wasn't towed, see if it was relocated
    if not @vehicle
      @relocated = true
      relocated_view = Windy.views.find_by_id(settings.relocated_view_id)
      relocated_vehicles = relocated_view.rows
      @vehicle = relocated_vehicles.find_by_plate(@plate_number)
    end

    erb :results
  end
end