require 'json'
require 'active_record'
require 'mysql'

module ApiHelper
  def post_errors?(params)
    if params['title'].nil? && params['content'].nil?
      return {
        status: 400,
        error: 'Need at least one parameter!'
      }
    elsif params['title'].blank? && params['content'].blank?
      return {
        status: 400,
        error: 'Cannot insert empty note!'
      }
    end
    nil
  end

  def put_errors?(params)
    if params['title'].nil? && params['content'].nil? && params['label'].nil?
      return {
        status: 400,
        error: 'Need at least one parameter!'
      }
    end
    nil
  end

  def search_errors?(params)
    if params['title'].nil? && params['content'].nil? && params['label'].nil?
      return {
        status: 404,
        error: 'What are you looking for?'
      }
    end
    nil
  end
end

module Settings
  def parse(filename)
    file = File.read(filename)
    config = JSON.parse(file)

    ActiveRecord::Base.establish_connection(
      adapter:  config['db']['adapter'],
      host:     config['db']['host'],
      user:     config['db']['user'],
      password: config['db']['password'],
      database: config['db']['name']
    )
    # Log queries
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    config
  end
end
