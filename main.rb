require './cron_expression_parser.rb'

while(1)
  new_command = gets
  if(new_command.chomp == 'exit')
    break
  elsif(new_command == "\n")
    next
  end
  cronparser = CronExpressionParser.new(new_command.chomp.strip)
  cronparser.parse
  cronparser.print_result
  print "\n"

end