module Cinch::Plugin
  class ConsoleCommand
    attr_reader :pattern
    
    def initialize(h)
      @pattern = h[:pattern]
      @method = h[:method]
    end

    def handle(plugin, line)
      if match = line.match(@pattern) then
        plugin.send(@method, *match.captures)
      end
    end
  end

  module ClassMethods
    attr_reader :console_commands

    m = method(:non_console_extended) rescue
    if not m then
      class << self
        alias_method :non_console_extended, :extended
        def extended(by)
          non_console_extended(by)
          by.instance_exec do
            @console_commands = []
          end
        end
      end
    end

    def console_command(pattern, method=:execute)
      @console_commands << ConsoleCommand.new(
          :pattern => pattern,
          :method  => method)
    end
  end

  def console_plugin
    if not @console_plugin then
      @console_plugin = bot.plugins.find { |plugin| plugin.class == ::Plugins::Console }
    end
    return @console_plugin
  end

  m = instance_method(:__register_non_console_commands) rescue
  if not m then
    def __register_console_commands
      (self.class.console_commands || [ ]).each do |cmd|
        console_plugin.register_console_command(self, cmd)
      end
    end

    alias_method :__register_non_console_commands, :__register
    def __register
      puts "register: #{self.inspect}"
      __register_non_console_commands
      __register_console_commands
    end
  end
end

module Plugins

class Console
  include Cinch::Plugin

  def initialize(bot)
    super(bot)
    @commands = [ ]
    @done = false
    start()
  end

  def start
    @thread = Thread.new do
      begin
        while not @done and line = $stdin.gets do
          @commands.each do |plugin, cmd|
            cmd.handle(plugin, line)
          end
        end
      rescue Exception
        p $!, $!.backtrace
      end
    end
  end

  def unregister
    @commands = [ ]
    @done = true
  end

  def register_console_command(plugin, cmd)
    bot.loggers.info "New console command #{cmd.inspect} handled by #{plugin}"
    @commands << [ plugin, cmd ] # TODO: ick
  end

  def execute(*args)
  end
end

end

