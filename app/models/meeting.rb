class Meeting < ActiveRecord::Base
  attr_accessible :body, :deadline, :duedate, :state
end
