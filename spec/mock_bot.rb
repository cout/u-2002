require 'cinch/helpers'
require 'cinch/pattern'
require 'cinch/plugin'
require 'cinch/handler'
require 'cinch/handler_list'
require 'cinch/logger_list'
require 'ostruct'

class MockBot
  attr_reader :config
  attr_reader :loggers
  attr_reader :handlers

  def initialize
    @config = OpenStruct.new
    @config.plugins = OpenStruct.new
    @loggers = Cinch::LoggerList.new
    @handlers = Cinch::HandlerList.new
  end
end

