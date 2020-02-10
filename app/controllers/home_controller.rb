class HomeController < ApplicationController

  def index 
  	render json: {status: "Loading.."}
  end
end
