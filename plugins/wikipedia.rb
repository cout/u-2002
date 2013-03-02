require 'open-uri'
require 'json'
require 'nokogiri'
require 'rexml/document'
require 'cgi'

module Plugins

class Wikipedia
  include Cinch::Plugin

  match /wikipedia\s+(.*)/
  match /wp\s+(.*)/

  set help: "wikipedia <page> - display wikipedia summary"

  def execute(m, page)
    s = wikipedia_summary(page)
    m.reply(s)
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
    # TODO: I tried to use Nokogiri to do the xpath, but
    # it didn't work, so here's a weird mixture of rexml
    # and nokogiri...
    file = open("http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?MaxHits=1&QueryString=#{CGI.escape(page)}")
    s = file.read
    d = REXML::Document.new(s)
    summaries = REXML::XPath.match(d, '//Description')
    if summaries.length == 0 or summaries[0].text == nil then
      return "#{page} not found"
    else
      summary = Nokogiri::HTML(summaries[0].text).text
      return summary
    end
  end

end

end
