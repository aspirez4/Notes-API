#!/usr/bin/ruby

# - базови CRUD операции: създаване, показване, редактиране и изтриване на бележки.
# - добавяне/премахване на етикети към бележките
# - търсене по заглавие, съдържание и/или етикети
# Приложение с конзолен интерфейс или работещо в browser-а, което да използва това API.
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql'
require 'pp'

set :port, 8080

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == 'admin' and password == 'fd3a85309aa5af451179268befa25567'
end

ActiveRecord::Base.establish_connection(
    :adapter => 'mysql',
    :host => 'localhost',
    :user => 'root',
    :password => 'password',
    :database => 'Notes'
)

class Notes < ActiveRecord::Base
end

class Labels < ActiveRecord::Base
end

# list all
get '/api/notes/?' do
  Notes.all.to_json
end

# view one
get '/api/notes/:id' do
  note = Notes.where(id: params[:id])
  return status 404 if note.nil?
  note.to_json
end

# create
post '/api/notes/?' do
  if params['title'].nil? and params['content'].nil?
    status 404
    return {:error => "Can't insert empty note?"}.to_json
  end

  note = Notes.new(
    title: params['title'],
    content: params['content']
  )
  note.save

  if params.has_key?('label')
    label = Labels.new(
        note_id: note.id,
        title: params['label']
    )
    label.save
  end

  status 201
end

# update
put '/api/notes/:id' do
  note = Notes.find(params[:id])
  return status 404 if note.nil?

  if params['title'].nil? and params['content'].nil? and params['label'].nil?
    status 404
    return {:error => 'Nothing to update'}.to_json
  end

  if params['title'].nil?
    note.update(title: params['title'])
  elsif params['content'].nil?
    note.update(content: params['content'])
  end

  note.save
  if params.has_key?('label')
    label = Labels.new(
        note_id: note.id,
        title: params['label']
    )
    label.save
  end

  status 202
end

delete '/api/notes/:id' do
  note = Notes.where(id: params[:id])
  return status 404 if note.nil?

  note.delete
  status 202
end