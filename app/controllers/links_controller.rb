require 'uri/http'

class LinksController < ApplicationController
  include Response
  include ExceptionHandler
  include Turl::UrlSafeBase59Encoder

  ID_OFFSET = 1000

  def create
    @link = Link.create!(link_params)
    token = b59encode(@link.id + ID_OFFSET)
    @link.shortened = URI::HTTP.build(host: request.host, scheme: request.scheme, port: request.port, path: "/#{token}")
    json(@link, :created)
  end

  private
  def link_params
    params.require(:link).permit(:original).except(:original, :id)
  end
end
