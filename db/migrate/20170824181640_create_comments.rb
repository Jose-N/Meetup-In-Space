class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :meetup
      t.string :body, null: false

      t.timestamps null: false
    end
  end
end
