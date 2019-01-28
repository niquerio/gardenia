require 'yaml'
class Gardenia 
  def initialize(input:, output:, plants:)
    @input = input
    @output = output
    @plants = plants
  end
  def run
    `touch #{@output}`
  end
end
