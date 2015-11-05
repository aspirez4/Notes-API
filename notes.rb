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
  note = Notes.new(params['note'])
  note.save
  status 201
end

# update
put '/api/notes/:id' do
  note = Notes.find(params[:id])
  return status 404 if note.nil?
  note.update(params[:note])
  note.save
  status 202
end

delete '/api/notes/:id' do
  note = Notes.find(params[:id])
  return status 404 if note.nil?
  note.delete
  status 202
end