class AddingUniquenessToRsvp < ActiveRecord::Migration
  def change
    add_index(:rsvps, [:user_id, :meetup_id], unique: true)
  end
end
