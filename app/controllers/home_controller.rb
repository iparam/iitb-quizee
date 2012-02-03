class HomeController < ApplicationController
  skip_before_filter :authenticate_user!,:only=>[:index]
  def index
  end
  def dashboard
    
  end
end
