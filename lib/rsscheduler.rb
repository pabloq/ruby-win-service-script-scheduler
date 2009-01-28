require 'yaml'
require 'rufus/scheduler'
require 'time'
class RSScheduler
    JOB_DONE = '1'
    def initialize conf
      @conf = conf
      @log_file,@log_file_err,@job_name,@scheduler = nil,nil,nil,nil
      require @conf[:script]
    end
    def start
        @scheduler = Rufus::Scheduler.start_new
        if @conf[:day]
          @scheduler.cron @conf[:day]  do
              run_day today
          end
        elsif @conf[:days]
          @conf[:days].each{|day|
            @scheduler.at(Time.parse(day), :discard_past => true)  do
              run_day today
            end
          }
        end
        @scheduler.join
    end
    def stop
      @scheduler.stop
    end
    def today
      "#{Time.now.year}#{Time.now.mon.to_s.rjust(2,'0')}#{Time.now.day.to_s.rjust(2,'0')}"
    end
    def run_day date
      @log_file = "#{@conf[:logs_path]}/#{date}_#{@conf[:logs_file_name]}.log"
      @log_file_err = "#{@conf[:logs_path]}/#{date}_#{@conf[:logs_file_name]}_err.log"
      @job_name = "#{@conf[:job_file_path]}/#{date}_#{@conf[:logs_file_name]}.job"
      puts "Running scheduler (day #{date}).."
      if !done?
        switch_log
        begin
          RSSS_runner.start @conf[:argv]
          set_default_log
          puts "Scheduler ran ok :D"
          done
        rescue
          set_default_log
          puts "Errors running scheduler please check..."
        end
      else
        puts "The script already  have done the job."
        puts "Check file:#{@job_name}"
      end
    end
    def done?
      done  = false
      if File.exist?(@job_name)
        temp  = File.new(@job_name,'r')
        done  = (temp.readlines[0][0..0]==JOB_DONE)
        temp.close
      end
      done
    end
    def done
      temp  = File.new(@job_name,'w')
      temp.puts JOB_DONE
      temp.close
    end
    def switch_log
          $stdout.close
          $stderr.close
          $stdout = File.new(@log_file, 'w')
          $stderr = File.new(@log_file_err, 'w')
    end
    def set_default_log()
          file_log  = "#{File.dirname(@conf[:script])}/#{File.basename(@conf[:script],'.rb')}.log"
          file_log_err  = "#{File.dirname(@conf[:script])}/#{File.basename(@conf[:script],'.rb')}_err.log"
          $stdout.close
          $stderr.close
          $stdout = File.new(file_log, 'a+')
          $stderr = File.new(file_log_err, 'a+')
    end
end