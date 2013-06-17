class Meeting < ActiveRecord::Base
  attr_accessible :body, :deadline, :duedate, :state

  has_many :meeting_collaborators
  has_many :users, :through => :meeting_collaborators
end
