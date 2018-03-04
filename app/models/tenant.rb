class Tenant < ApplicationRecord
  after_create do
    begin
      Apartment::Tenant.create(name)
    rescue Apartment::TenantExists => e
      puts "Tenant #{name} already exists. Skipping..."
    end
  end
end
