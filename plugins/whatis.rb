require 'shellwords'

class WhatisPlugin
  include Cinch::Plugin

  match /whatis(?:\s+)(\S+)(?:\s+)?(\S+)?/

  def execute(m, name, section)
    m.reply(whatis(name, section))
  end

  def whatis(name, section=nil)
    cmd = [
      "whatis",
      Shellwords.escape(name),
    ]
    if section then
      cmd << '-s'
      cmd << Shellwords.escape(section)
    end
    return `#{Shellwords.join(cmd)} 2>&1`
  end
end

