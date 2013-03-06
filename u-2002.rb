require 'cinch'

require './plugins/console'
require './plugins/reload'
require './plugins/help'
require './plugins/weather'
require './plugins/man'
require './plugins/units'
require './plugins/rpn'
require './plugins/eval'
require './plugins/coin'
require './plugins/score'
require './plugins/wikipedia'
require './plugins/conservapedia'
require './plugins/slashtitle'

require "cinch/plugins/basic_ctcp"
require "cinch/plugins/yamlscore"
require "cinch/plugins/urbandictionary"

class Cinch::Plugins::YamlScore
  set help: "scores - display all scores\n" + \
            "score <user> - show score for <user>\n" + \
            "user +1 - increase score for user\n" + \
            "etc."
end

class Cinch::Plugins::UrbanDictionary
  set help: "urban <word> - look up <word> in the Urban Dictionary"
end

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
      Plugins::Coin,
      Plugins::Score,
      Plugins::Wikipedia,
      Plugins::Conservapedia,
      Plugins::Slashtitle,
      Cinch::Plugins::BasicCTCP,
      Cinch::Plugins::UrbanDictionary,
    ]
    c.plugins.prefix = '.'
  end
end

bot.start

