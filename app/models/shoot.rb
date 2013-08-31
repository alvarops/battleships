class Shoot < ActiveRecord::Base
  belongs_to :board
  belongs_to :player
end
