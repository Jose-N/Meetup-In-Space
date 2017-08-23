class RemoveAttendeesFromMeetups < ActiveRecord::Migration
  def change
    remove_column(:meetups, :attendees_user_ids)
  end
end
