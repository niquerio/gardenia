require_relative './plant.rb'
require 'yaml'
require 'csv'
require 'erb'
require 'byebug'
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
		File.open(@output, "w"){|file| file.write ScheduleErbRenderer.new(@calendar.weeks).render }
  end
end

class ScheduleErbRenderer
	include ERB::Util
	def initialize(weeks)
		@weeks = weeks
	end
	def get_template
		File.read(File.join(__dir__,'./schedule.txt.erb')) 
	end
	def render
		ERB.new(get_template, nil, '-').result(binding)
	end
end

class Calendar
	def initialize
		@weeks = Array.new
	end
	def add_plant(plant:, num:)
		week_counter = plant.transplant_week
                puts plant.name
		plant.steps.reverse.each do |s|
			week_counter = week_counter - s.weeks
			week = find_or_create_week(week_counter)
			week.add_task(Task.new(step: s, num: num))
		end
	end
	def weeks
		@weeks.sort{|a,b| a.num <=> b.num } 
	end
	private
	def find_or_create_week(week_num)
		week = nil
		@weeks.each do |w|
			week = w if w.num == week_num
	  end	
		if week.nil?
			week = Week.new(week_num)
			@weeks.push(week)
		end
		week
	end
end

class Week
	attr_reader :num
  def initialize(num)
    @num = num		
		@categories = Array.new
	end
	def add_task(task)
		cat = find_or_create_category(task.step)
		cat.add_task(task)
	end
	def to_s
		GardenWeek.new(@num).to_s
	end
	def categories
	  @categories
		@categories.sort{|a,b| a.order <=> b.order }
	end
	private
	def find_or_create_category(step)
		cat = nil
		@categories.each do |c|
			cat = c if c.name == step.heading
	  end	
		if cat.nil?
			cat = Category.new(name: step.heading, order: step.order)
			@categories.push(cat)
		end
		cat
	end
end

class Category
	attr_reader :name, :tasks, :order
	def initialize(name:, order:)
		@name = name
		@tasks = Array.new
		@order = order
	end
	def add_task(task)
		@tasks.push(task)
	end
	def to_s
		name
	end
end

class Task
	attr_reader :step
	def initialize(step:, num:)
	  @step	= step
		@num = num
  end
	def to_s
		@step.to_s(@num)
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
				transplant_week: p["transplant_week"], steps: Array.new)
		        plant.steps = generate_steps(p["steps"],plant)
			@plants[p["name"]] = plant
		end
	end
	def generate_steps(steps, plant)
		my_steps = []
	        steps.each do |s|
			case s["type"]
			when 'first_flat'
				if s["spacing"] == 'broadcast'
		      my_steps.push(FirstFlatBroadcast.new(weeks: s["weeks"], spacing: s["spacing"], plant: plant))
				else
		      my_steps.push(FirstFlat.new(weeks: s["weeks"], spacing: s["spacing"], plant: plant))
				end
			when 'second_flat'
		    my_steps.push(SecondFlat.new(weeks: s["weeks"], spacing: s["spacing"], depth: s["depth"], plant: plant))	
			end
		end	
	  my_steps.push(HardenOff.new(plant))	
	  my_steps.push(Transplant.new(plant))	
		my_steps
	end
end

class GardenWeek
	attr_reader :last_frost, :week
	def initialize(week=0)
	  @last_frost = Date.parse("May 3, #{Date.today.year}")	
		@week = @last_frost + (week*7)
		@week_num = week
	end

	def to_s
		"#{last_frost_distance}: Week of #{week.strftime("%B %-d")}" 
	end	

	def last_frost_distance
	  if @week_num < -1	
	    "#{@week_num.abs} Weeks Before Last Frost"		
		elsif @week_num == -1
			"1 Week Before Last Frost"
	  elsif @week_num == 0
			"Last Frost"		
	  elsif @week_num == 1
			"1 Week After Last Frost"
		else
			"#{@week_num} Weeks After Last Frost"
		end
	end
  	
end
