class Meetup < ActiveRecord::Base
  has_many :rsvps, :dependent => :destroy
  has_many :users, through: :rsvps 
  has_many :comments, :dependent => :destroy
  validates :name, presence: true
  validates :description, presence: true
  validates :location, presence: true
  validates :creator, presence: true
end
