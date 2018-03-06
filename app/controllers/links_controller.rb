require 'uri/http'
require 'httparty'

class LinksController < ApplicationController
  include Response
  include ExceptionHandler
  include HTTParty
  include Turl::UrlSafeBase59Encoder

  ID_INIT_OFFSET = 500_000

  def create
    local_link_params = link_params
    existing_link = Link.find_by original: local_link_params['original']
    if !existing_link.nil?
      logger.info "Found an existing shortened link for #{local_link_params['original']}"
      link_to_render = existing_link
    else
      logger.info "Create a new link for #{local_link_params['original']}"
      Link.transaction do
        @link = Link.create!(local_link_params)
        verify_original(@link.original)
        @link.shortened = URI::HTTP.build(
          host:   request.host,
          scheme: request.scheme,
          port:   request.port,
          path:   "/#{b59encode(@link.id + ID_INIT_OFFSET)}"
        )
        @link.save!
        link_to_render = @link
      end
    end
    render_link(link_to_render)
  end

  def render_link(link)
    # technically the existing link shouldn't return 201 Created but returning something else would be an information leak
    json(link, %w[created_at updated_at id], :created)
  end

  def verify_original(original)
    logger.info("Verifying the original link: #{original}")
    begin
      resp = self.class.get original,
                            headers: { 'User-Agent' => Turl::Application.config.user_agent_for_verify },
                            timeout: Turl::Application.config.link_verify_timeout
    rescue SocketError, Net::OpenTimeout
      raise Turl::CannotConnectOriginal, original
    end
    if (resp.code >= 400) && (resp.code <= 599)
      raise Turl::CannotVerifyOriginal.new(original, resp.code)
    end
  end

  def follow
    shortened = URI::HTTP.build(
      host:   request.host,
      scheme: request.scheme,
      port:   request.port,
      path:   request.path
    )

    link = Link.find_by shortened: shortened.to_s
    raise Turl::OriginalLinkNotFound, request.path if link.nil?
    logger.info("Original link found for #{link}")
    render location: link.original, status: :found
  end

  private

  def link_params
    link = params.require(:link).permit(:original)
    raise Turl::OriginalLinkTooLong if link['original'].size > Link::MAX_LENGTH
    raise Turl::OriginalLinkEmpty if link['original'].empty?
    raise Turl::OriginalLinkSchemeInvalid \
      unless link['original'].starts_with?('http://') || link['original'].starts_with?('https://')
    link
  end
end
