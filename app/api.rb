require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'notes'
require_relative 'labels'
require_relative 'api_helper'

include ApiHelper
include Settings

##################################
# CONFIG
##################################
CONFIG_PATH = '/home/admin-pc/development/notes-api/config/config.json'
config = Settings.parse(CONFIG_PATH)
set :port, config['sinatra_port']

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == config['username'] && password == config['password']
end

##################################
# READ ALL
##################################
get '/api/notes/?' do
  status 200
  Notes.retrieve_all.to_json
end

##################################
# READ
##################################
get '/api/notes/:id' do
  result = Notes.retrieve_element(params[:id])
  if result.nil?
    status 404
    return {
      status: 404,
      error: 'Element with such ID does not exist!'
    }.to_json
  else
    status 200
    return result.to_json
  end
end

##################################
# SEARCH
##################################
get '/api/search' do
  params = request.env['rack.request.query_hash']

  errors = ApiHelper.search_errors?(params)
  unless errors.nil?
    status errors.fetch(:status)
    return errors.to_json
  end

  result = Notes.search(params)
  if result.nil?
    status 404
  else
    status 200
    result.to_json
  end
end

##################################
# CREATE
##################################
post '/api/notes/?' do
  errors = ApiHelper.post_errors?(params)
  unless errors.nil?
    status errors.fetch(:status)
    return errors.to_json
  end

  note = Notes.create(
    title: params['title'],
    content: params['content']
  )

  note_id = note.note_id
  Labels.add(params['label'], note_id) if params.key?('label') && note_id

  status 201
end

##################################
# UPDATE
##################################
put '/api/notes/:id' do
  errors = ApiHelper.put_errors?(params)
  unless errors.nil?
    status errors.fetch(:status)
    return errors.to_json
  end

  note = Notes.find_by(note_id: params[:id])
  return status 404 if note.nil?

  note.update(title: params['title']) if params.key?('title')
  note.update(content: params['content']) if params.key?('content')
  note.save

  Labels.add(params['label'], note.note_id) if params.key?('label')

  status 202
end

##################################
# DELETE
##################################
delete '/api/notes/:id' do
  note = Notes.find_by(note_id: params[:id])
  return status 404 if note.nil?

  note.delete
  status 202
end
