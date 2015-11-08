class ApiHelper
  def self.post_errors?(params)
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

  def self.put_errors?(params)
    if params['title'].nil? && params['content'].nil? && params['label'].nil?
      return {
        status: 400,
        error: 'Need at least one parameter!'
      }
    end
  end
end
