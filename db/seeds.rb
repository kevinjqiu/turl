case Rails.env
when "test"
  Tenant.create([{ name: 'alpha' }, { name: 'beta' }])
when "development"
  Tenant.create([{ name: 'alpha' }, { name: 'beta' }])
when "production"
  Tenant.create([{ name: 'alpha' }, { name: 'beta' }])
end
