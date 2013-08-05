class StripesController < ApplicationController
  
  
  def create
    event = request.body.read.log
    render :text => ""
  end
  
end
