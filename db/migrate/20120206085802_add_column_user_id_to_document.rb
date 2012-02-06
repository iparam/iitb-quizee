class AddColumnUserIdToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :user_id, :integer

  end
end
