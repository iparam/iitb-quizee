class Document < ActiveRecord::Base
  belongs_to :user
  mount_uploader  :asset, DocumentUploader
  validates_presence_of   :name
  validates_uniqueness_of :name,:message => "Name already taken"
  validates_format_of :name ,:with =>  /[A-Z|a-z]/ ,:allow_blank => true ,:allow_nil => true
end
