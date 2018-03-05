require 'uri/http'
require 'httparty'

class LinksController < ApplicationController
  include Response
  include ExceptionHandler
  include HTTParty
  include Turl::UrlSafeBase59Encoder

  ID_OFFSET = 500000

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
      json(@link, ["created_at", "updated_at", "id"], :created)
    end
  end

  def verify_original(original)
    begin
      resp = self.class.get original
    rescue SocketError, Net::OpenTimeout
      raise Turl::CannotConnectOriginal.new(original)
    end
    if resp.code >= 400 and resp.code <= 599
      raise Turl::CannotVerifyOriginal.new(original, resp.code)
    end
  end

  def follow
    #request.path
  end

  private
  def link_params
    link = params.require(:link).permit(:original)
    raise Turl::OriginalLinkTooLong.new if link['original'].size > Link::MAX_LENGTH
    raise Turl::OriginalLinkEmpty.new if link['original'].empty?
    raise Turl::OriginalLinkSchemeInvalid.new unless link['original'].starts_with?('http://') or link['original'].starts_with?('https://')
    link
  end
end
