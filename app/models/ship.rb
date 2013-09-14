require 'ship_shapes'

class Ship < ActiveRecord::Base
  include ShipShapes
  has_many :positions, dependent: :delete_all

  belongs_to :board

  validates_inclusion_of :t, :in => [:carrier, :battleship, :submarine, :cruiser, :patrol, :worm, :uBoot]

  def t
    read_attribute(:t).to_sym
  end

  def t= (value)
    write_attribute(:t, value.to_s)
  end

  def self.generate(t, width, height)
    ship = Ship.new :t => t
    variants = ShipShapes::SHIP_TYPES[t.to_sym]
    coordinates = variants.sample
    start_x = Random.new.rand(0..width-(ship_width coordinates) +1)
    start_y = Random.new.rand(0..height-(ship_height coordinates)+1)

    coordinates.each do |c|
      p = Position.new :x => c[:x] + start_x, :y => c[:y] + start_y
      ship.positions.push p
    end
    ship
  end

  def self.ship_width(p)
    1 + (max_value_in_hash p, 'x')
  end

  def self.ship_height(p)
    1+ (max_value_in_hash p, 'y')
  end

  def print_ship(board_width=20, board_height=20)
    #puts self.t
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
      #puts row
    end
  end

  def collide?(ship2)
    self.positions.each do |p1|
      ship2.positions.each do |p2|
        if p1.collision? p2
          return true
        end
      end
    end
    false
  end

  def status
    sunk = false
    hit = self.positions.any? { |p| p.hit }
    if hit
      sunk = self.positions.all? { |p| p.hit }
    end
    return :sunk if sunk
    return :hit if hit
    return :clear
  end

  private
  def self.max_value_in_hash(p, key)
    max = 0
    p.each do |pos|
      if (pos[key.to_sym] > max)
        max = pos[key.to_sym]
      end
    end
    max
  end
end