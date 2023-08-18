module Exceptions
  class InvalidExpression < StandardError
    attr_reader :message
    def initialize(message = 'Invalid Expression please check')
      super
      @message = message
    end
  end
end