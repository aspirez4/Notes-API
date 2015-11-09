def read_config(filename)
  file = File.read(filename)
  JSON.parse(file)
end

CONFIG_PATH = '/home/admin-pc/development/notes-api/config/config.json'
config = read_config(CONFIG_PATH)

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == config['username'] && password == config['password']
end

configure :production, :development do
  set :port, config['sinatra_port']
  
  ActiveRecord::Base.establish_connection(
    adapter:  config['db']['adapter'],
    host:     config['db']['host'],
    user:     config['db']['user'],
    password: config['db']['password'],
    database: config['db']['name']
  )
  # Log queries
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
