class WelcomeController < ApplicationController
  def index
  	render json: { message: 'Welcome to the cowtribe api' }
  end
end
