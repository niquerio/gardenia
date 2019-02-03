class Plant
	attr_reader :name, :germination_rate, :transplant_week
  attr_accessor :steps
	def initialize(name:, germination_rate:, transplant_week:, steps:)
		@name = name
		@germination_rate = germination_rate
		@transplant_week = transplant_week
		@steps = Array.new
	end
  
end


class Step
	attr_reader :heading, :weeks, :plant, :order
	def initialize(heading:,weeks:,plant:)
		@heading = heading
		@weeks = weeks
    @plant = plant
    @order = 0
	end

  def to_s(num)
    "#{@plant.name}: #{amount(num)} seedlings"
  end
  private
  def amount(num)
    num
  end
end

class FirstFlat < Step
  def initialize(weeks:, spacing:, plant:)
		@heading = 'Start seedlings in flats' 
	  @weeks = weeks
    @spacing = spacing
		@description = "at #{spacing} in. spacing"	
    @plant = plant
    @order = 1
	end

  def to_s(num)
    "#{@plant.name}: #{amount(num)} seeds at #{@spacing} in. spacing" 
  end
  private
  def amount(num)
   (num / @plant.germination_rate).ceil
  end
end

class FirstFlatBroadcast < FirstFlat
  def to_s(num)
    "#{@plant.name}: #{amount(num)} seeds broadcast"
  end
end
class SecondFlat < Step
  def initialize(weeks:, spacing:, depth:, plant:)
		@heading = 'Prick out seedlings into flats' 
	  @weeks = weeks
    @spacing = spacing
    @depth = depth
    @plant = plant
    @order = 2
	end
  def to_s(num)
    "#{@plant.name}: #{amount(num)}+ seedlings at #{@spacing} in. spacing in #{@depth} in. deep flats"
  end
  
end
class HardenOff < Step
  def initialize(plant)
		@heading = 'Harden off'
		@weeks = 1
    @plant = plant
    @order = 3
  end
end
class Transplant < Step
  def initialize(plant="#CHANGEME")
		@heading = 'Transplant'
		@weeks = 0
    @plant = plant
    @order = 4
  end
end
