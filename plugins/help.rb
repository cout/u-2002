module Plugins

class Help
  include Cinch::Plugin

  match /help$/

  def execute(m)
    help_plugins = bot.plugins.select { |plugin| has_help(plugin) }
    topics = help_plugins.collect { |plugin| topic(plugin) }
    m.reply("Available topics: #{topics.join(' ')}")
  end
  
  def has_help(plugin)
    return plugin.class.help ? true : false
  end

  def topic(plugin)
    return plugin.class.plugin_name
  end
end

end

