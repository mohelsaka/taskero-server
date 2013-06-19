class User < ActiveRecord::Base
  validates :email, :uniqueness => true, :allow_blank => false
  validates :registration_id, :uniqueness => true, :allow_blank => false

  attr_accessible :email, :state, :registration_id
end
