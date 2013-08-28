class Ship < ActiveRecord::Base
  has_many :positions, dependent: :delete_all

  belongs_to :board

  validates_inclusion_of :t, :in => [:carrier, :battleship, :submarine, :cruiser, :patrol]

  def t
    read_attribute(:t).to_sym
  end
  def t= (value)
    write_attribute(:t, value.to_s)
  end
end
