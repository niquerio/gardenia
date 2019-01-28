#!/usr/bin/env ruby

require 'pathname'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path("../../Gemfile", Pathname.new(__FILE__).realpath)
$LOAD_PATH.unshift File.expand_path('../../lib', Pathname.new(__FILE__).realpath)
require 'bundler/setup'
require 'optparse'

plants_file = File.join((File.expand_path('..',__dir__)), 'lib', 'plants.yaml')
options = {input: '', output: './schedule.txt', plants: plants_file}

OptionParser.new do |opts|
  opts.on("-i", "--input InputFile", "Path to input file") do |input|
    options[:input] = input  
  end
  opts.on("-o", "--output OutputFile", "Path to output file") do |output|
    options[:output] = output
  end
  opts.on("-p", "--plants PlantsFile", "Path to plants file") do |plants|
   options[:plants] = plants
  end
  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!
puts options
