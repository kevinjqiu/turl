module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      json({ message: e.message }, [], :unprocessable_entity)
    end

    rescue_from Turl::CannotVerifyOriginal do |e|
      json({ message: "Cannot verify original #{e.original}: code=#{e.response_code}" }, [], :unprocessable_entity)
    end

    rescue_from Turl::CannotConnectOriginal do |e|
      json({ message: "Cannot connect original #{e.original}" }, [], :unprocessable_entity)
    end
  end
end
