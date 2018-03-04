module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      json({ message: e.message }, :unprocessable_entity)
    end
  end
end
