class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :registerable,
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :documents ,:dependent => :destroy  
  
  has_many :folders ,:dependent => :destroy
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,:admin,:super_admin,:name

  
  # If super_admin field is enable then current_user is authorized 
  def is_admin?
    self.admin
  end
  
  def is_super_admin?
    self.super_admin
  end
  
end
