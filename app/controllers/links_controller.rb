class LinksController < ApplicationController
  include Response
  include ExceptionHandler

  def create
    @link = Link.create!(link_params)
    @link[:shortened] = tokenizer.tokenize(@link[:original])
    json(@link, :created)
  end

  private
  def link_params
    params.require(:link).permit(:original).reject(:shortened).reject(:id)
  end

  def tokenizer
    return Tokenizer.new
  end
end

class Tokenizer
  ALPHABET = Array("0".."9") + Array("a".."z") + Array("A".."Z") + ["-", "_"] - ["o", "O", "i", "I", "l"]

  def tokenize(n)
  end
end
