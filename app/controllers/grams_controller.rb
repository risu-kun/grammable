class GramsController < ApplicationController

  def index
  end
  
  def new
    @gram = Gram.new
  end

end
