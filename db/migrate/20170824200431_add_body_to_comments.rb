class AddBodyToComments < ActiveRecord::Migration
  def change
    add_column :comments, :body, :string, null: false
  end
end
