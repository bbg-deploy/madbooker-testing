class StripesController < ApplicationController
  
  
  def index
    event = request.body.read.log
    render :text => ""
  end
  
end
