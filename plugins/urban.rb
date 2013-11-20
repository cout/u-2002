require 'open-uri'
require 'json'
require 'cgi'

module Plugins

class UrbanDictionary
  include Cinch::Plugin

  match /urban\s+(.*)/

  set help: "urban| <term> - display urban dictionary entry"

  def execute(m, term)
    s = summary(term)
    s = truncate_message(s, 3)
    m.reply(s)
  end

  def summary(term)
    bot.loggers.info "Getting urban dictionary entry for #{term}"

    url = "http://api.urbandictionary.com/v0/define?term=#{CGI.escape(term)}"
    bot.loggers.info "Retrieving #{url}"

    file = open(url)
    json = file.read
    h = JSON.parse(json)
    if h['list'].empty? then
      return "Could not find #{term}"
    else
      return h['list'][0]['definition']
    end
  end

end

end
