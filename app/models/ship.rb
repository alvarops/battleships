class Ship < ActiveRecord::Base
  include ShipModels

  has_many :positions, dependent: :delete_all

  belongs_to :board

  validates_inclusion_of :t, :in => [:carrier, :battleship, :submarine, :cruiser, :patrol, :worm, :uBoot, :tie_fighter, :enterprise, :death_star, :s1, :kursk, :crab, :chess, :s3, :s4, :a, :o, :l]

  def t
    read_attribute(:t).to_sym
  end

  def t= (value)
    write_attribute(:t, value.to_s)
  end

  def width
    1 + (max_value_in_hash self.positions, 'x')
  end

  def height
    1 + (max_value_in_hash self.positions, 'y')
  end

  def print_ship (board_width = 20, board_height = 20)
    board_height.times do |y|
      row=''
      board_width.times do |x|
        pixel = nil
        self.positions.each do |p|
          if (p.x.equal? x) && (p.y.equal? y)
            pixel = p
          end
        end
        row += pixel ? '[]' : '.^'
      end
    end
  end

  def collide?(ship2)
    self.positions.each do |p1|
      ship2.positions.each do |p2|
        return true if p1.collision? p2
      end
    end
    false
  end

  def status
    hit  = self.positions.any? &:hit
    sunk = self.positions.all? &:hit

    return :sunk if sunk
    return :hit  if hit
    return :clear
  end

end