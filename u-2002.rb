require 'cinch'
require 'yaml'

require './plugins/console'
require './plugins/reload'
require './plugins/help'
require './plugins/weather'
require './plugins/spaceweather'
require './plugins/man'
require './plugins/units'
require './plugins/rpn'
require './plugins/eval'
require './plugins/coin'
require './plugins/score'
require './plugins/wikipedia'
require './plugins/conservapedia'
require './plugins/slashtitle'
require './plugins/protolol'

require "cinch/plugins/basic_ctcp"
require "cinch/plugins/yamlscore"
require "cinch/plugins/urbandictionary"

class Cinch::Plugins::UrbanDictionary
  set help: "urban <word> - look up <word> in the Urban Dictionary"
end

config = YAML.load_file('config.yml')

bot = Cinch::Bot.new do
  configure do |c|
    c.server = config['server']
    c.nick = config['nick']
    c.channels = config['channels']
    c.plugins.plugins = [
      Plugins::Console,
      Plugins::Reload,
      Plugins::Help,
      Plugins::Weather,
      Plugins::SpaceWeather,
      Plugins::Man,
      Plugins::Units,
      Plugins::Rpn,
      Plugins::Eval,
      Plugins::Coin,
      Plugins::Score,
      Plugins::Wikipedia,
      Plugins::Conservapedia,
      Plugins::Slashtitle,
      Plugins::Protolol,
      Cinch::Plugins::BasicCTCP,
      Cinch::Plugins::UrbanDictionary,
    ]
    c.plugins.prefix = config['prefix'] || '.'
  end
end

bot.start

