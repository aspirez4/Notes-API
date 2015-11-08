require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'settings'
require_relative 'notes'
require_relative 'labels'

CONFIG_PATH = '/home/admin-pc/development/notes-api/config/config.json'

config = Settings.parse(CONFIG_PATH)

set :port, config['sinatra_port']

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == config['username'] && password == config['password']
end

get '/api/notes/?' do
  status 200
  Notes.retrieve_all.to_json
end

get '/api/notes/:id' do
  result = Notes.retrieve_element(params[:id])
  if result.nil?
    status 404
    return { error: 'Element with such ID do not exists!' }.to_json
  else
    status 200
    return result.to_json
  end
end

get '/api/search' do
  result = Notes.search(request.env['rack.request.query_hash'])
  if result.nil?
    status 404
  else
    status 200
    result.to_json
  end
end

post '/api/notes/?' do
  if params['title'].nil? && params['content'].nil?
    status 400
    return { error: 'Need at one parameter!' }.to_json
  elsif params['title'].blank? && params['content'].blank?
    status 400
    return { error: 'Cannot insert empty note!' }.to_json
  end

  note = Notes.create(
    title: params['title'],
    content: params['content']
  )
  note_id = note.note_id

  Labels.add(params['label'], note_id) if params.key?('label') && note_id

  status 201
end

# TO DO
# 1. Update/delete label
put '/api/notes/:id' do
  if params['title'].nil? && params['content'].nil? && params['label'].nil?
    status 400
    return { error: 'Need at least 1 parameter!' }.to_json
  end

  note = Notes.find_by(note_id: params[:id])
  return status 404 if note.nil?

  if params.key?('title')
    note.update(title: params['title'])
  elsif params.key?('content')
    note.update(content: params['content'])
  end
  note.save

  if params.key?('label')
    labels = params['label'].split(',')

    labels.each do |name|
      label = Labels.new(
        note_id: note.note_id,
        label: name.strip
      )
      label.save
    end
  end

  status 202
end

delete '/api/notes/:id' do
  note = Notes.find_by(note_id: params[:id])
  return status 404 if note.nil?

  note.delete
  status 204
end
