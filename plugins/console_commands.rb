module Plugins

class ConsoleCommands
  include Cinch::Plugin

  console_command /msg\s+(.*?)\s+(.*)/, :msg
  console_command /nick\s+(.*)/, :nick

  def msg(dest, msg)
    target = Cinch::Target.new(dest, @bot)
    target.msg(msg)
  end

  def nick(nick)
  puts "changing nick to #{nick}"
    @bot.nick = nick
  end
end

end
