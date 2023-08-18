class String
  def numeric?
    Integer(self) != nil rescue false
  end
end