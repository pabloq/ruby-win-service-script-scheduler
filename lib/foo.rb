class Foo
  def initialize(param1,param2)
    @param1,@param2 = param1,param2
  end
  def to_s
    "Hello world! param1 = #{@param1}, param2 = #{@param2}\nThis must be see in my script logs."
  end
end