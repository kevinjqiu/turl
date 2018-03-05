module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      json({ message: e.message }, [], :unprocessable_entity)
    end

    rescue_from Turl::TurlException do |e|
      json({ message: e.message }, [], e.response_code)
    end
  end
end
