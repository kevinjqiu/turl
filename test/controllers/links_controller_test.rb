require 'test_helper'

class LinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    WebMock.enable!
    Tenant.create({name: 'alpha'})
    Tenant.create({name: 'beta'})
  end

  teardown do
    Apartment::Tenant.drop('alpha')
    Apartment::Tenant.drop('beta')
    WebMock.reset!
  end

  def assert_shortened_link_created(tenant)
    stub_request(:get, 'good.example.com')
    Apartment::Tenant.switch! tenant
    post_json "http://#{tenant}.lvh.me/links", { original: 'http://good.example.com' }
    assert_response :created
    assert_not response_json['shortened'].nil?
    assert response_json['shortened'].starts_with? "http://#{tenant}."
  end

  test 'create a simple shortened link' do
    assert_shortened_link_created 'alpha'
  end

  test 'create a simple shortened link on another tenant' do
    assert_shortened_link_created 'beta'
  end

  test 'shorten a previously shortened link will return the previous shortened link' do
    stub_request(:get, 'good.example.com')
    Apartment::Tenant.switch! 'alpha'
    post_json 'http://alpha.lvh.me/links', { original: 'http://good.example.com' }
    assert_response :created
    shortened = response_json['shortened']
    post_json 'http://alpha.lvh.me/links', { original: 'http://good.example.com' }
    assert_response :created
    assert_equal shortened, response_json['shortened']
  end

  test 'original url too long' do
    post_json 'http://alpha.lvh.me/links', { original: "http://www.example.com/#{'a' * 2084}" }
    assert_response 400
  end

  test 'original url is javascript:' do
    post_json 'http://alpha.lvh.me/links', { original: "javascript:alert('foo')" }
    assert_response 400
  end

  test 'original url is empty' do
    post_json 'http://alpha.lvh.me/links', { original: '' }
    assert_response 400
  end

  def assert_origin_verification_error
    Apartment::Tenant.switch! "alpha"
    post_json 'http://alpha.lvh.me/links', { original: 'http://www.example.com' }
    assert_response :unprocessable_entity
  end

  test 'original url verification error on 4xx' do
    stub_request(:get, 'www.example.com').to_return(status: 404)
    assert_origin_verification_error
  end

  test 'original url verification error on 5xx' do
    stub_request(:get, 'www.example.com').to_return(status: 503)
    assert_origin_verification_error
  end

  test 'original url verification error on timeout' do
    stub_request(:get, 'www.example.com').to_timeout
    assert_origin_verification_error
  end

  test 'original url verification error connection error' do
    stub_request(:get, 'www.example.com').to_raise SocketError.new
    assert_origin_verification_error
  end

  test 'follow a non-existent link' do
    Apartment::Tenant.switch! 'alpha'
    get 'http://alpha.lvh.me/nonexistent'
    assert_response :not_found
  end

  test 'follow a good link' do
    stub_request(:get, 'good.example.com').to_return(status: 200, body: 'VERY GOOD')
    Apartment::Tenant.switch! 'alpha'
    stub_request(:get, 'good.example.com')
    post_json 'http://alpha.lvh.me/links', { original: 'http://good.example.com' }
    assert_response :created
    get response_json['shortened']
    assert_response :found
    assert_equal 'http://good.example.com', response.headers['Location']
  end
end
