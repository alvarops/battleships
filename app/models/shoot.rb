class Shoot < ActiveRecord::Base
  include TimestampSuppress

  belongs_to :game
  belongs_to :player
end
