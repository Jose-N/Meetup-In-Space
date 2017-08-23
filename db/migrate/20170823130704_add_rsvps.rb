class AddRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |table|
      table.belongs_to :users, index: true
      table.belongs_to :meetups, index: true
    end
  end
end
