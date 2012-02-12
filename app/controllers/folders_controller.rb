class FoldersController < ApplicationController
  
  authorize_resource
  def new
  end
  
  def create
    if params[:folder][:parent_id].present?
       @last_folder = Folder.where("parent_id = ?",params[:folder][:parent_id]).order("id desc").limit(1)
      #@last_folder = Folder.find_by_parent_id(params[:folder][:parent_id],:order => "id desc",:limit => 1)
    else
      @last_folder = Folder.where("parent_id IS ?",nil).order("id desc").limit(1)
    end
  
    @folder = current_user.folders.create(params[:folder])
    
    respond_to do |format|
      if @folder.save
        flash[:type] = "success"
        flash[:message] = "Folder Successfully Created"
        format.js 
      else
        flash[:type] = "error"
        flash[:message] = "Error!!!"     
      end  
     end
  end

  def tree_structure
    folder = Folder.find(params[:id])
    folders   =  Folder.where("parent_id =?", folder.id).order("folders.id").includes(:user)
    documents =  Document.where("folder_id =?",folder.id).includes(:user)
    @assets = folders + documents
    @parent_id = folder.id  
    render :layout => false
  end

  def folder_tree
  
  end
  
  def edit
  end
  
  def show
    @parent_id = params[:id]
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
