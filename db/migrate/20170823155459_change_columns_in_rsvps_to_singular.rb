class ChangeColumnsInRsvpsToSingular < ActiveRecord::Migration
  def change
    rename_column(:rsvps, :users_id, :user_id, )
    rename_column(:rsvps, :meetups_id, :meetup_id, )
  end
end
