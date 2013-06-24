class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.string :body
      t.integer :deadline
      t.integer :duedate
      t.string :state

      t.timestamps
    end
  end
end
