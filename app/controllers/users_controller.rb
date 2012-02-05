class UsersController < ApplicationController
 load_and_authorize_resource

	def index
		@users = User.all
		@user = User.new if current_user.is_admin? || current_user.is_super_admin?
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(params[:user])
		respond_to do |format|
		  if @user.save
		  
			  flash[:notice] = "Successfully created User."
			  format.html{redirect_to(users_path,:notice=>"Successfully created User.")}
			  format.js
		  else
        format.html{render :action => 'new'}
			  format.js{render :template => 'layouts/error',:locals=>{:object=>@user}}
		  end
		end
	end

	def edit


		if current_user.is_admin? || current_user.is_super_admin? 
			@user = User.find(params[:id])
		else
			@user = current_user
		end
	end

	def update
		if current_user.admin?
			@user = User.find(params[:id])
		else
			@user = current_user
		end
    params[:user].delete(:email) if params[:user][:email] != @user.email
		params[:user].delete(:password) if params[:user][:password].blank?
		params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
		respond_to do |format|
		if @user.update_attributes(params[:user])
			flash[:notice] = "Successfully updated User."
			format.html{redirect_to(users_path,:notice=>"Successfully updated User.")}
			format.js
		else
			format.html{render :action => 'edit'}
			format.js{render :template => 'layouts/error',:locals=>{:object=>@user}}
		end
		end
	end

	def destroy
		@user = User.find(params[:id])
		if @user.destroy
			flash[:notice] = "Successfully deleted User."
			redirect_to users_path
		end
	end
end
