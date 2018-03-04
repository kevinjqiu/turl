class Tenant < ApplicationRecord
  after_create do
    begin
      Apartment::Tenant.create(name)
    rescue StandardError => e
      #puts e
    end
  end
end
