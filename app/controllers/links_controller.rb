require 'uri/http'
require 'httparty'

class LinksController < ApplicationController
  include Response
  include ExceptionHandler
  include HTTParty
  include Turl::UrlSafeBase59Encoder

  ID_OFFSET = 1000

  def create
    Link.transaction do
      @link = Link.create!(link_params)
      verify_original(@link.original)
      @link.shortened = URI::HTTP.build(
        host:   request.host,
        scheme: request.scheme,
        port:   request.port,
        path:   "/#{b59encode(@link.id + ID_OFFSET)}"
      )
      @link.save!
      json(@link, :created)
    end
  end

  def verify_original(original)
    begin
      resp = self.class.get original
      if resp.code >= 400 and resp.code <= 599
        raise Turl::CannotVerifyOriginal.new(original, resp.code)
      end
    rescue SocketError, Net::OpenTimeout
      raise Turl::CannotConnectOriginal.new(original)
    end
  end

  private
  def link_params
    params.require(:link).permit(:original)
  end
end
