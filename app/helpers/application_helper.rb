module ApplicationHelper
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
  def sidebar_enabled?
      pages = %w(
      
                documents.index        
              
              )   
          
      page = controller.controller_name+"."+controller.action_name
      pages.include?(page)       
  end

  def sidebar_present
    sidebar_enabled? ? "with-sidebar" : ""
  end
  
  def sidebar_class
    sidebar_enabled? ? "grid_4" : "no-sidebar"
  end
  
  def grid_class
    sidebar_enabled? ? "grid_12" : "grid_16"
  end
  
  
 
  

end
