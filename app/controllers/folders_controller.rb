class FoldersController < ApplicationController
  
  authorize_resource
  def new
  end
  
  def create
    @folder = current_user.folders.create(params[:folder])
    if @folder.save
      flash[:type] = "success"
      flash[:message] = "Folder Successfully Created"
    else
      flash[:type] = "error"
      flash[:message] = "Error!!!"
    end  
    render :layout => false
  end
  
  def edit
  end
  
  def show
    folders = Folder.find(params[:id]).children 
    documents = Folder.find(params[:id]).documents
    @assets = folders + documents
    render :layout => false   
  end
  
  def update
  end
  
  def destroy
  end
  
  def move
  end
end
