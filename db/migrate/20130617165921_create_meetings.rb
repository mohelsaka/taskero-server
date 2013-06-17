class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :body
      t.date :deadline
      t.date :duedate
      t.string :state

      t.references :user

      t.timestamps
    end
  end
end
