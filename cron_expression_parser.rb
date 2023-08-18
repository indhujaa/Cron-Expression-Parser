require 'colorize'
require './exceptions/invalid_expression'
require './overrides/string'
SEPARATORS = [',','-','/']
WEEK_DAYS = ['SUN','MON','TUE','WED','THUR','FRI','SAT']
MONTHS = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC']
class CronExpressionParser
  def initialize(expression)
    @expression = expression
    @result = {}
  end

  def parse
    @result={
      status: true,
      msg: 'Success',
      data: validator,
    }
  rescue Exceptions::InvalidExpression => e
    @result={
      status: false,
      msg: e.message,
      data: {  }
    }
  end

  def print_result
    if(@result[:status])
      @result[:data].keys.each do |key|
        title =(key.to_s).gsub('_',' ')
        print (title+(' '*(14-title.length))).green
        print " ",@result[:data][key].sort.uniq().join(' ').green
        print "\n"
      end
    else
      puts @result[:msg].red
    end
  end

  private

    def validator
      splits=@expression.split(" ")
      if(splits.length == 6)
        {
          'minute': separator_check(splits[0], 0,59,'minute'),
          'hour': separator_check(splits[1], 0,23,'hour'),
          'day_of_month': separator_check(splits[2],1,31,'day_of_month'),
          'month': separator_check(splits[3],1,12,'month'),
          'day_of_week': separator_check(splits[4],1,7,'week'),
          'command': [splits[5]]
        }
      else
        raise Exceptions::InvalidExpression
      end
    end

    def separator_check(value,min,max,type)
      if(value == '*')
        (min..max).to_a
      elsif(value.numeric? && value.to_i>=min && value.to_i<=max)
        [value.to_i]
      elsif(value.include?(','))
        res = value.split(',')
        (res.map{|v| separator_check(v,min,max,type)}).flatten
      elsif(value.include?('/'))
        res = value.split('/')
        if(res[1].numeric?  && res[1].to_i>=min && res[1].to_i<=max)
          separator_check(res[0],min,max,type).select{|v| v%res[1].to_i==0}
        else
          raise Exceptions::InvalidExpression
        end
      elsif(value.include?('-'))
        res = (value.split('-').map{|v| letter_to_num(v,type)}).flatten
        if(res[0]>=min && res[1]<=max && res[0]<=res[1])
          (res[0]..res[1]).to_a
        else
          raise Exceptions::InvalidExpression
        end
      else
        [letter_to_num(value,type)]
      end
    end

    def letter_to_num(value,type)
      unless(value.numeric?)
        value.upcase!
        if(type == 'month' && MONTHS.include?(value))
          MONTHS.find_index(value.upcase)+1
        elsif(type == 'week' && WEEK_DAYS.include?(value))
            WEEK_DAYS.find_index(value)+1
        else
          raise Exceptions::InvalidExpression
        end
      else
        value.to_i
      end
    end
end