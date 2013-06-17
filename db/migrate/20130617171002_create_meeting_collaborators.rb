class CreateMeetingCollaborators < ActiveRecord::Migration
  def change
    create_table :meeting_collaborators do |t|

      t.timestamps

      t.references :user
      t.references :meeting
    end
  end
end
