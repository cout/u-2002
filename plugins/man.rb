require 'shellwords'

module Plugins

class Man
  include Cinch::Plugin

  match /whatis(?:\s+)(\S+)(?:\s+(\S+))?/,
        method: :whatis

  match /proto(?:\s+)(\S+)(?:\s+(\S+))?/,
        method: :proto

  set help: "whatis <name> [section]\n" + \
            "proto <name> [section]\n"

  def whatis(m, name, section)
    bot.loggers.info "Getting whatis for #{name} in section[s] #{section}"

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
    section ||= "3,2"
    bot.loggers.info "Getting proto for #{name} in section[s] #{section}"

    sections = section.split ','

    sections.each do |section|
      proto = proto_for(name, section)
      if proto then
        m.reply(proto)
        return
      end
    end

    m.reply "no prototype for #{name} found in section[s] #{section}"
  end

  def proto_for(name, section)
    cmd = [ "man" ]
    if section then
      cmd << "-S"
      cmd << Shellwords.escape(section)
    end
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
          return $1
        end
      end                                                                  
    end

    return nil
  end

  def unformat(line)
    return line.gsub(/.\010/, '')
  end
end

end

