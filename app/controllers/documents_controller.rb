class DocumentsController < ApplicationController
  
  authorize_resource
  
  def index
    
    folders   =  Folder.where("parent_id is ?", nil).order("folders.id").includes(:user)
    documents =  Document.where("folder_id IS ?",nil).includes(:user)
    @folders = Folder.where("parent_id is ?",nil)
    @assets = folders + documents
    @parent_id = nil
  end
  
  def new
    @document =  current_user.documents.new
  end
  
  def create

    @document = current_user.documents.new(params[:document])
    respond_to do |format|
      if @document.save
        format.js
      else
        render :action => :new  
      end
    end
  end
  
  def show
     @document = Document.find(params[:id])
  end
  
  def edit
    @document =  current_user.documents.find(params[:id])
  end
  
  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      redirect_to documents_path
    else
      render :action => :new  
    end
  end
  
  def destroy
    @document = Document.find(params[:id])
    if @document.destroy
      flash[:notice] = "File Deleted"
      redirect_to documents_path
    else
      flash[:notice] = "Something Went Wrong While deleting"
    end
  end
  
  def download
    @document = Document.find(params[:id])
    send_file(@document.asset.file.file)
  end
end

