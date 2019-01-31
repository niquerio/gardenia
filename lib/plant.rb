class Plant
	attr_reader :name, :germination_rate, :transplant_week, :steps
	def initialize(name:, germination_rate:, transplant_week:, steps:)
		@name = name
		@germination_rate = germination_rate
		@transplant_week = transplant_week
		@steps = steps
	end
end


class Step
	attr_reader :heading, :weeks, :description
	def initialize(heading:,weeks:,description:)
		@heading = heading
		@weeks = weeks
		@description = description
	end

  def amount(num)
    "#{num} seedlings"    
  end
end

class FirstFlat < Step
  def initialize(weeks:, spacing:)
		@heading = 'Start seedlings in flats' 
	  @weeks = weeks
		@description = "at #{spacing} in. spacing"	
	end

  def amount(num)
    "#{num} seeds"
  end

  
end
class SecondFlat < Step
  def initialize(weeks:, spacing:, depth:)
		@heading = 'Prick out seedlings into flats' 
	  @weeks = weeks
		@description = "at #{spacing} in. spacing in #{depth} in. deep flats"	
	end
  def amount(num)
    "#{num}+ seedlings"    
  end
end
class HardenOff < Step
  def initialize
		@heading = 'Harden off'
		@weeks = 1
		@description = ''
  end
end
class Transplant < Step
  def initialize
		@heading = 'Transplant'
		@weeks = 0
		@description = ''
  end
end
