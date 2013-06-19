class AddRegistrationIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :registration_id, :string
  end
end
