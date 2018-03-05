ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'json'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def post_json(url, obj)
    post url, params: obj.to_json, headers: { 'Content-Type': 'application/json' }
  end

  def response_json
    JSON.parse(response.body)
  end
end
