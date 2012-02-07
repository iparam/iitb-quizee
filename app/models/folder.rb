class Folder < ActiveRecord::Base
 has_many :documents,:dependent => :destroy  
 belongs_to :user
 acts_as_tree :order => "name"
end
