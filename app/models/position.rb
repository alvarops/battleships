class Position < ActiveRecord::Base
  include TimestampSuppress

  belongs_to :ship
end
