class ChangeMeetingIntegerToBigint < ActiveRecord::Migration
  def up
  	change_column :meetings, :deadline, :bigint
  	change_column :meetings, :duedate, :bigint
  end

  def down
  end
end
