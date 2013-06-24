class AddStatusToMeetingCollaboratorTable < ActiveRecord::Migration
  def change
  	add_column :meeting_collaborators, :state, :string
  end
end
