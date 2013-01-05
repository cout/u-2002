require 'shellwords'

class ManPlugin
  include Cinch::Plugin

  match /whatis(?:\s+)(\S+)(?:\s+)?(\S+)?/,
        method: :whatis

  match /proto(?:\s+)(\S+)(?:\s+)?(\S+)?/,
        method: :proto

  def whatis(m, name, section)
    cmd = [
      "whatis",
      Shellwords.escape(name),
    ]
    if section then
      cmd << '-s'
      cmd << Shellwords.escape(section)
    end

    m.reply `#{Shellwords.join(cmd)} 2>&1`
  end

  def proto(m, name, section)
    cmd = [ "man" ]
    cmd << Shellwords.escape(section) if section
    cmd << Shellwords.escape(name)

    synopsis = false
    IO.popen("#{Shellwords.join(cmd)} 2>&1").each_line do |line|
      case unformat(line)                                                  
      when /^SYNOPSIS/                                                     
        puts "HAVE SYNOPSIS"
        synopsis = true                                                    
      when /^DESCRIPTION/                                                  
        synopsis = false                                                   
      when /^\s*(.*#{name}\s*\(.*\))/                                      
        if synopsis then
          m.reply($1)
          return
        end
      end                                                                  
    end
  end

  def unformat(line)
    return line.gsub(/.\010/, '')
  end
end

