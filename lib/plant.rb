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
end

class FirstFlat < Step
  def initialize(weeks:, spacing:)
		@heading = 'Start seedlings in flats' 
	  @weeks = weeks
		@description = "#{spacing} in. spacing"	
	end
end
class SecondFlat < Step
  def initialize(weeks:, spacing:, depth:)
		@heading = 'Prick out seedlings into flats' 
	  @weeks = weeks
		@description = "#{spacing} in. spacing in #{depth} in. deep flats"	
	end
end
