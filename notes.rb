#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'active_record'
require 'mysql'

ActiveRecord::Base.establish_connection(
    :adapter => "mysql",
    :host => "localhost",
    :user => "root",
    :password => "password",
    :database => "notes"
)

class Notes < ActiveRecord::Base
end

# list all
get '/api/notes' do
  Notes.all.to_json
end

# view one
get '/api/notes/:id' do
  note = Notes.find(params[:id])
  return status 404 if note.nil?
  note.to_json
end

# create
post '/api/notes' do
  return 'You have to post something here :)' if params['title'].nil?
  note = Notes.new(
            title: params['title'],
            content: params['content'],
            label: params['label']
  )

  note.save
  status 201
end

# update
put '/api/notes/:id' do
  note = Notes.find(params[:id])
  return status 404 if note.nil?
  note.update(
      title: params['title'],
      content: params['content'],
      label: params['label']
  )
  note.save
  status 202
end

delete '/api/notes/:id' do
  note = Notes.find(params[:id])
  return status 404 if note.nil?

  note.delete
  status 202
end