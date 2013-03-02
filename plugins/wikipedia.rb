require 'open-uri'
require 'json'
# require 'nokogiri'
require 'rexml/document'
require 'cgi'

module Plugins

class Wikipedia
  include Cinch::Plugin

  match /wikipedia\s+(.*)/

  set help: "wikipedia <page> - display wikipedia summary"

  def execute(m, page)
    m.reply(wikipedia_summary(page))
  end

  # def wikipedia_summary(page)
  #   bot.loggers.info "Getting wikipedia summary for #{page}"

  #   url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&redirects=yes&page=#{CGI.escape(page)}"
  #   bot.loggers.info "Retrieving #{url}"

  #   file = open(url)
  #   json = file.read
  #   h = JSON.parse(json)
  #   html = h['parse']['text']['*']
  #   summary = /<p>(.*)<\/p>/.match(html)[1]
  #   text = Nokogiri::HTML(summary).text

  #   return text
  # end

  def wikipedia_summary(page)
    file = open("http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?MaxHits=1&QueryString=#{CGI.escape(page)}")
    s = file.read
    d = REXML::Document.new(s)
    summary = REXML::XPath.match(d, '//Description')[0].text
    return summary
  end

end

end
