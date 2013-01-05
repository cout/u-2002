class ReloadPlugin
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
      file, line = plugin.method(:execute).source_location
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

