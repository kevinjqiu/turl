require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest

  setup do
    Tenant.create({name: "alpha"})
  end

  teardown do
    Apartment::Tenant.drop("alpha")
  end

  test "shorten a simple link" do
    skip
    Apartment::Tenant.switch! "alpha"
    post_json 'http://alpha.lvh.me/links', { original: 'http://www.google.com' }
    assert_response :created
    assert_not response_json[:shortened].nil?
  end
end
