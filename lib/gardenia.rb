require_relative './plant.rb'
require 'yaml'
class Gardenia 
	attr_reader :plants
  def initialize(input:, output:, plants:)
    @input = input
    @output = output
    @plants = PlantsParser.new(plants).plants
		@calendar = Calendar.new
  end
  def run
		
		CSV.foreach(@input) do |row|
		  @calendar.add_plant(plant: @plants[row[0]], num: row[1].to_i)	
		end
		File.open(@output, "w"){|file| file.puts @calendar }
  end
end

class Calendar
	attr_reader :weeks
	def initialize
		@weeks = {}
	end
	def add_plant(plant:, num:)
		week_counter = plant.transplant_week
		plant.steps.reverse.each do |s|
			week_counter = week_counter - s.weeks
			my_num = num
      my_num = (num / plant.germination_rate).ceil if s.class.to_s == "FirstFlat"
			@weeks[week_counter] = Hash.new if @weeks[week_counter].nil?
			@weeks[week_counter][s.heading] = Array.new if @weeks[week_counter][s.heading].nil?
			my_plant = "#{plant.name}: #{s.amount(my_num)}"
			my_plant << " #{s.description}"  unless s.description == ""
			@weeks[week_counter][s.heading].push(my_plant) 
				
		end
	end

	def to_s
    my_s = ""
		@weeks.sort.each do |week, v|    
	    my_s << GardenWeek.new(week).to_s	+ "\n"
			v.each do |step, plants|
				my_s << "  #{step}\n"
				plants.each do |p|
					my_s << "    #{p}\n"
				end
			end
		end
		my_s
	end

end

class PlantsParser
	attr_reader :plants
	def initialize(plants_file)
	  @plants_data = YAML.load_file(plants_file)
		@plants = {}
		run
	end
	private
	def run
		@plants_data.each do |p|
			plant = Plant.new(name: p["name"], germination_rate: p["germination_rate"],
				transplant_week: p["transplant_week"], steps: generate_steps(p["steps"]))
			@plants[p["name"]] = plant
		end
	end
	def generate_steps(steps)
		my_steps = []
	  steps.each do |s|
			case s["type"]
			when 'first_flat'
		    my_steps.push(FirstFlat.new(weeks: s["weeks"], spacing: s["spacing"]))	
			when 'second_flat'
		    my_steps.push(SecondFlat.new(weeks: s["weeks"], spacing: s["spacing"], depth: s["depth"]))	
			end
		end	
	  my_steps.push(HardenOff.new)	
	  my_steps.push(Transplant.new)	
		my_steps
	end
end

class GardenWeek
	attr_reader :last_frost, :week
	def initialize(week=0)
	  @last_frost = Date.parse("May 3, #{Date.today.year}")	
		@week = @last_frost + (week*7)
	end

	def to_s
		"Week of #{week.strftime("%B %-d")}" 
	end	
end
