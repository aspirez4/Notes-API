require 'json'
require 'active_record'
require 'mysql'
require 'sinatra'

class Settings
  $config
  def self.parse(filename)
    file = File.read(filename)
    $config = JSON.parse(file)

    ActiveRecord::Base.establish_connection(
        :adapter =>   $config['db']['adapter'],
        :host =>      $config['db']['host'],
        :user =>      $config['db']['user'],
        :password =>  $config['db']['password'],
        :database =>  $config['db']['name']
    )
    # Log queries
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end
end