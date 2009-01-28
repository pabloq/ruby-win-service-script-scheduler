require 'foo'
class RSSS_runner
  class << self
    def start argv=nil
      process = Foo.new(argv[0],argv[1])
      puts process
    end
  end
end