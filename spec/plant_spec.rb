require_relative '../lib/plant.rb'
describe Plant do
  it 'returns appropriate input' do
    plant = Plant.new(name: 'Broccoli', germination_rate: 0.5, transplant_week: 6, steps: Array.new)
    expect(plant.name).to eq('Broccoli')
  end
end

