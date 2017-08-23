class AddAttendeesToMeetups < ActiveRecord::Migration
  def change
    add_column :meetups, :attendees_user_ids, :integer
  end
end
