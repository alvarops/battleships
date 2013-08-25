class Ship < ActiveRecord::Base
  has_many :positions, dependent: :delete_all
end
