class AddColumnAssetToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :asset, :string
  end
end
