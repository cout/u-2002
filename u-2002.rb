require 'cinch'
require './plugins/console'
require './plugins/reload'
require './plugins/help'
require './plugins/weather'
require './plugins/man'
require './plugins/units'
require './plugins/rpn'
require './plugins/eval'

bot = Cinch::Bot.new do
  configure do |c|
    # c.server = 'irc.freenode.org'
    c.server = 'localhost'
    c.nick = 'U-2002'
    c.channels = [ '#alt-255' ]
    c.plugins.plugins = [
      Plugins::Console,
      Plugins::Reload,
      Plugins::Help,
      Plugins::Weather,
      Plugins::Man,
      Plugins::Units,
      Plugins::Rpn,
      Plugins::Eval,
    ]
    c.plugins.prefix = '.'
  end
end

bot.start

