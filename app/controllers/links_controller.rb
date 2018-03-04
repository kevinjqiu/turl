class LinksController < ApplicationController
  include Response
  include ExceptionHandler

  def create
    @link = Link.create!(link_params)
    json(@link)
  end

  private
  def link_params
    params.require(:link).permit(:original)
  end
end
