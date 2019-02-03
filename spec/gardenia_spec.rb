require 'byebug'
require 'csv'
require 'date'
require 'fileutils'
require_relative '../lib/gardenia.rb'
describe Gardenia do
  before(:each) do
    @gardenia = Gardenia.new(input: './spec/fixtures/broccoli_input.csv', output: 'my_output.txt', plants: './spec/fixtures/broccoli.yaml')
  end
	after(:each) do
		File.delete('./my_output.txt') if File.exists?('./my_output.txt')
	end
  it 'returns a schedule for good input' do
    @gardenia.run
    expect(File.read('./my_output.txt')).to eq(File.read('./spec/fixtures/good_output.txt'))
  end 
  it 'has a plants hash' do
    expect(@gardenia.plants.class.to_s).to eq('Hash')
  end
  it 'has a plants hash that containts Plants' do
    expect(@gardenia.plants['broccoli'].class.to_s).to eq('Plant')
  end
end
describe PlantsParser do
  before(:each) do
    @pparser = PlantsParser.new('./spec/fixtures/broccoli.yaml')
  end
  it "generates a plants hash" do
    expect(@pparser.plants.class.to_s).to eq('Hash')
  end
  it "has plants has with Plants in it" do 
    expect(@pparser.plants['broccoli'].class.to_s).to eq('Plant')
  end
  context "one broccoli plant" do
    before(:each) do
      @broc = @pparser.plants['broccoli']
    end
    it "has first step to have superclass 'Step'" do
      expect(@broc.steps[0].class.superclass.to_s).to eq('Step')
    end
    it "has steps with superclass step" do
      uniq = @broc.steps.map{|x| x.class.superclass.to_s}.uniq 
      expect(uniq.count).to eq(1)
      expect(uniq.first).to eq('Step')
    end
    it "has 4 steps" do
      expect(@broc.steps[0].class.to_s).to eq('FirstFlat')
      expect(@broc.steps[1].class.to_s).to eq('SecondFlat')
      expect(@broc.steps[2].class.to_s).to eq('HardenOff')
      expect(@broc.steps[3].class.to_s).to eq('Transplant')
    end
  end
end
describe GardenWeek do
  it "returns last frost date of May 3" do
    last_frost = Date.parse("May 3, #{Date.today.year}")
    expect(GardenWeek.new.last_frost).to eq(last_frost)
  end
  describe "to_s" do
    it "prints month and day for without 0 padding for one digit day" do
      expect(GardenWeek.new.to_s).to eq("Week of May 3")
    end
    it "prints month and day for for appropriate week" do
      expect(GardenWeek.new(1).to_s).to eq("Week of May 10")
    end
    it "prints full month" do
      expect(GardenWeek.new(-1).to_s).to eq("Week of April 26")
    end
  end
end
