require 'rspec'
require_relative 'cron_expression_parser'

RSpec.describe CronExpressionParser do
  describe '.parse' do
    it 'parses cron expression 0 4 8-14 * * test_command' do
      expression = '0 4 8-14 * * test_command'
      parsed_result = (CronExpressionParser.new(expression).parse)[:data]

      expect(parsed_result[:minute]).to eq([0])
      expect(parsed_result[:hour]).to eq([4])
      expect(parsed_result[:day_of_month]).to eq([8,9,10,11,12,13,14])
      expect(parsed_result[:month]).to eq([1,2,3,4,5,6,7,8,9,10,11,12])
      expect(parsed_result[:day_of_week]).to eq([1,2,3,4,5,6,7])
      expect(parsed_result[:command]).to eq(['test_command'])
    end
  end

  it 'parses cron expression 0 4 8-14 * * test_command' do
    expression = '23 0-20/2 2-10 * * test_command'
    parsed_result = (CronExpressionParser.new(expression).parse)[:data]
    expect(parsed_result[:minute]).to eq([23])
    expect(parsed_result[:hour]).to eq([0,2,4,6,8,10,12,14,16,18,20])
    expect(parsed_result[:day_of_month]).to eq([2,3,4,5,6,7,8,9,10])
    expect(parsed_result[:month]).to eq([1,2,3,4,5,6,7,8,9,10,11,12])
    expect(parsed_result[:day_of_week]).to eq([1,2,3,4,5,6,7])
    expect(parsed_result[:command]).to eq(['test_command'])
  end

  it 'Invalid cron expression 3 0-20/2 10-1 * * test_command' do
    expression = '23 0-20/2 10-1 * * test_command'
    parsed_result = (CronExpressionParser.new(expression).parse)
    expect(parsed_result[:status]).to eq(false)
  end

  it 'Invalid cron expression 3 0-20/2 10-1 * *' do
    expression = '23 0-20/2 10-1 * *'
    parsed_result = (CronExpressionParser.new(expression).parse)
    expect(parsed_result[:status]).to eq(false)
  end

  it 'parses cron expression 0 0,12 1 */2 * test_command' do
    expression = '0 0,12 1 */2 * test_command'
    parsed_result = (CronExpressionParser.new(expression).parse)[:data]
    expect(parsed_result[:minute]).to eq([0])
    expect(parsed_result[:hour]).to eq([0,12])
    expect(parsed_result[:day_of_month]).to eq([1])
    expect(parsed_result[:month]).to eq([2,4,6,8,10,12])
    expect(parsed_result[:day_of_week]).to eq([1,2,3,4,5,6,7])
    expect(parsed_result[:command]).to eq(['test_command'])
  end


end