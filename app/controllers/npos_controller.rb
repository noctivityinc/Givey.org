class NposController < ApplicationController
  def index
    @npos = Npo.all
  end
end
