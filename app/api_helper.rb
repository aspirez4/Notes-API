require 'json'
require 'active_record'
require 'mysql'

module ApiHelper
  def check_post_errors(params)
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

  def check_put_errors(params)
    if params['title'].nil? && params['content'].nil? && params['label'].nil?
      return {
        status: 400,
        error: 'Need at least one parameter!'
      }
    end
    nil
  end

  def check_search_errors(params)
    if params['title'].nil? && params['content'].nil? && params['label'].nil?
      return {
        status: 404,
        error: 'What are you looking for?'
      }
    end
    nil
  end
end
