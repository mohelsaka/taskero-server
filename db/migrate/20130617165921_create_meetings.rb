class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :body
      t.datetime :deadline
      t.datetime :duedate
      t.string :state

      t.timestamps
    end
  end
end
