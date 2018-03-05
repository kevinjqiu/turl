class LinksController < ApplicationController
  include Response
  include ExceptionHandler
  include Turl::Tokenizer

  def create
    @link = Link.create!(link_params)
    @link[:shortened] = tokenize(@link[:original])
    json(@link, :created)
  end

  private
  def link_params
    params.require(:link).permit(:original).except(:original, :id)
  end
end
