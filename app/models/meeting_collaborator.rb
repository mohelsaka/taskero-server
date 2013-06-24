class MeetingCollaborator < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :meeting

  def decline
    update_attribute(:state, 'declined')
  end

  def accept
    update_attribute(:state, 'accepted')
  end
end
