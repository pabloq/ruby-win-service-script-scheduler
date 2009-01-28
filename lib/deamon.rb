conf = YAML::load_file(ARGV[0])
file_log  = "#{File.dirname(conf[:script])}/#{File.basename(conf[:script],'.rb')}.log"
file_log_err  = "#{File.dirname(conf[:script])}/#{File.basename(conf[:script],'.rb')}_err.log"
$stdout,$stderr = File.new(file_log, 'a+'),File.new(file_log_err, 'a+')
$stdout.sync = true
begin
require 'win32/daemon'
require "#{File.dirname(__FILE__)}/rsscheduler"
include Win32
  class Daemon
    @scheduler = nil
    def service_main
      while running? 
        @scheduler =  RSScheduler.new YAML::load_file(ARGV[0])
        @scheduler.start
      end
    end
    def service_stop
      puts @scheduler.stop
      puts "STOP signal (#{Time.now.to_s})"
    end
    def service_start
      puts "START signal (#{Time.now.to_s})"
    end
  end
   Daemon.mainloop
rescue Exception => err
   puts "Scheduler Daemon failure: #{err} (#{Time.now.to_s})"
   raise
end