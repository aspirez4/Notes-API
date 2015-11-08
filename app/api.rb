require 'sinatra'
require 'sinatra/reloader'
require 'pp' # pretty print
require 'json'
require_relative 'settings'
require_relative 'notes'
require_relative 'labels'

Settings.parse('config.json')

set :port, $config['sinatra_port']
use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == $config['username'] and password == $config['password']
end

# TODO:
# 1. Limit query!
# 2. Paging
get '/api/notes/?' do
  status 200
  Notes.retrieve_all.to_json
end

# TODO:
# 1. get multiple id's
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

# TODO:
# 1. AND label search
get '/api/search' do
  params = request.env['rack.request.query_hash']
  result = Notes.where('title LIKE ? AND content LIKE ?', "%#{params['title']}%", "%#{params['content']}%")

  status 200
  result.to_json
end

post '/api/notes/?' do
  if params['title'].nil? and params['content'].nil?
    status 400
    return {:error => 'I need at least title or content parameters!'}.to_json
  elsif params['title'].blank? and params['content'].blank?
    status 400
    return {:error => 'Cannot insert empty note!'}.to_json
  end

  note = Notes.create(
    title: params['title'],
    content: params['content']
  )

  if params.key?('label') and note.note_id
    Labels.add(params['label'], note.note_id)
  end

  status 201
end

# TO DO
# 1. Update/delete label
put '/api/notes/:id' do
  if params['title'].nil? and params['content'].nil? and params['label'].nil?
    status 400
    return {
        error: 'Need at least 1 parameter [title, content, label]!'
    }.to_json
  end

  note = Notes.find_by(note_id: params[:id])
  return status 404 if note.nil?

  if params.key?('title')
    note.update(title: params['title'])
  end

  if params.key?('content')
    note.update(content: params['content'])
  end

  note.save
  if params.key?('label')
    labels = params['label'].split(',')

    labels.each do |note|
      label = Labels.new(
          note_id: note.note_id,
          label: note.strip
      )
      label.save
    end
  end

  status 202
end

# TO DO: add deletion of multiple ids
delete '/api/notes/:id' do
  note = Notes.find_by(note_id: params[:id])
  return status 404 if note.nil?

  note.delete
  status 202
end

