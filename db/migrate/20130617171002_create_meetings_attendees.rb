class CreateMeetingsAttendees < ActiveRecord::Migration
  def change
    create_table :meetings_attendees do |t|

      t.timestamps

      t.references :user
      t.references :meeting
    end
  end
end
