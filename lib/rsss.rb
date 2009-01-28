require "win32/service"
class RSSS
  include Win32
  def initialize conf
    @conf = YAML::load_file(conf)
    @cmd = "c:/ruby/bin/ruby.exe \"#{File.dirname(__FILE__)}/deamon.rb\" \"#{conf}\""
  end
  def install
    Service.create(@conf[:service_code], nil,
    :description        => @conf[:description],
    :start_type         => Service::AUTO_START,
    :error_control      => Service::ERROR_NORMAL,
    :binary_path_name   => @cmd,
    :display_name       => @conf[:service_name])
  end
  def start
      Service.start(@conf[:service_code])
  end
  def pause
      Service.pause(@conf[:service_code])
  end
  def resume
      Service.resume(@conf[:service_code])
  end
  def stop
      Service.stop(@conf[:service_code])
  end
  def delete
    Service.delete(@conf[:service_code])
  end
  def status
    Service.status(@conf[:service_code])
  end
  def to_s
    s = "#{'*'*40}\nRSSS configuration\n#{'*'*40}\n"
    @conf.each{|a,b|
      s+="#{a}:#{b}(#{b.class})\n"
    }
    s+='*'*40
  end
end