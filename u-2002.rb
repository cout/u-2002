require 'cinch'
require './plugins/console'
require './plugins/reload'
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
      ConsolePlugin,
      ReloadPlugin,
      WeatherPlugin,
      ManPlugin,
      UnitsPlugin,
      RpnPlugin,
      EvalPlugin,
    ]
    c.plugins.prefix = '.'
  end
end

bot.start

