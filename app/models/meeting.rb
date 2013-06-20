class Meeting < ActiveRecord::Base
  attr_accessible :body, :deadline, :duedate, :state, :collaborators

  has_many :meeting_collaborators
  has_many :users, :through => :meeting_collaborators

  def collaborators=(_collaborators)
  	self.users << _collaborators.map {|collaborator| User.find_or_create_by_email(collaborator)}
  end
end
