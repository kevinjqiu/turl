require 'test_helper'

class TenantTest < ActiveSupport::TestCase
  test 'create tenant model should create a apartment tenant' do
    Tenant.create(name: 'test_subdomain')
    tenants = Apartment::Tenant.each {}
    assert tenants.include? 'test_subdomain'
  end

  test 'create multiple tenants' do
    Tenant.create([{ name: 'alpha' }, { name: 'beta' }])
    tenants = Apartment::Tenant.each {}
    assert_equal tenants, %w[alpha beta]
  end
end
