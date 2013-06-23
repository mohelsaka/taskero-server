class ChangeDuedateAndDeadlineInMeeingToInteger < ActiveRecord::Migration
  def up
  	change_column :meetings, :duedate, :integer
  	change_column :meetings, :deadline, :integer
  end

  def down
  	change_column :meetings, :duedate, :datetime
  	change_column :meetings, :deadline, :datetime
  end
end
