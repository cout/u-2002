require 'open-uri'
require 'json'
require 'nokogiri'
require 'cgi'

module Plugins

class Conservapedia
  include Cinch::Plugin

  match /conservapedia\s+(.*)/
  match /cp\s+(.*)/

  set help: "conservapedia|cp <page> - display wikipedia summary"

  def execute(m, page)
    s = summary(page)
    m.reply(s)
  end

  def summary(page)
    bot.loggers.info "Getting conservapedia summary for #{page}"

    url = "http://www.conservapedia.com/api.php?action=parse&format=json&prop=text&section=0&redirects=yes&page=#{CGI.escape(page)}"
    bot.loggers.info "Retrieving #{url}"

    file = open(url)
    json = file.read
    h = JSON.parse(json)
    html = h['parse']['text']['*']
    n = Nokogiri::XML("<div>#{html}</div>")
    summary = n.xpath('//p')[0].text

    return summary
  end

end

end
