module Plugins

class Reload
  include Cinch::Plugin

  console_command /reload/

  def execute(m)
    reload_all_plugins
  end

  def reload_all_plugins
    plugins = bot.plugins.dup
    plugins.each do |plugin|
      bot.loggers.info "Reloading #{plugin}"
      reload_plugin(plugin)
    end
  end

  def reload_plugin(plugin)
    begin
      method_name = (plugin.class.matchers + plugin.class.listeners + plugin.class.hooks.values).first.method
      file, line = plugin.method(method_name).source_location
      return if not File.exists?(file)
      bot.plugins.unregister_plugin(plugin)
      begin
        load "#{file}"
      ensure
        bot.plugins.register_plugin(plugin.class)
      end
    rescue Exception => e
      bot.loggers.error "Unable to reload #{plugin}: #{e}"
    end
  end
end

end

