require 'fileutils'
require_relative '../lib/gardenia.rb'
describe Gardenia do
	after(:each) do
		File.delete('./my_output.txt')
	end
  it 'returns a schedule for good input' do
    Gardenia.new(input: './spec/basic_input.yaml', output: 'my_output.txt', plants: './spec/plants.yaml').run	  	
    expect(File.read('./my_output.txt')).to eq(File.read('./spec/fixtures/good_output.txt'))
  end 
end
