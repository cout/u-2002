require 'cinch'
require 'yaml'

require './lib/truncate_message'

require './plugins/console'
require './plugins/console_commands'
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
require './plugins/bible'
require './plugins/etymonline'
require './plugins/urban'

require "cinch/plugins/basic_ctcp"
require "cinch/plugins/yamlscore"

config = YAML.load_file('config.yml')

bot = Cinch::Bot.new do
  configure do |c|
    c.server = config['server']
    c.nick = config['nick']
    c.channels = config['channels']
    c.plugins.plugins = [
      Plugins::Console,
      Plugins::ConsoleCommands,
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
      Plugins::Bible,
      Plugins::Etymonline,
      Plugins::UrbanDictionary,
      Cinch::Plugins::BasicCTCP,
    ]
    c.plugins.prefix = config['prefix'] || '.'
    c.max_messages = 3
  end
end

bot.start

