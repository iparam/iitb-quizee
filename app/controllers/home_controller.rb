class HomeController < ApplicationController
  skip_before_filter :authenticate_user!,:only=>[:index]
  skip_authorization_check :only => [:index,:dashboard]
  def index
  
  end
  
  def dashboard
    
  end
end
