require 'open-uri'
require 'json'
require 'nokogiri'
require 'rexml/document'
require 'cgi'

module Plugins

class Wikipedia
  include Cinch::Plugin

  match /wikipedia\s+(.*)/, method: :execute_wikipedia_summary
  match /wp\s+(.*)/, method: :executed_wikipedia_summary

  match /dbpedia\s+(.*)/, method: :execute_dbpedia_summary
  match /dbp\s+(.*)/, method: :execute_dbpedia_summary

  set help: "wikipedia <page> - display wikipedia summary\n"
            "dbpedia <page> - display dbpedia summary\n"

  def executed_wikipedia_summary(m, page)
    s = wikipedia_summary(page)
    s = truncate_message(s, 3)
    m.reply(s)
  end

  def execute_dbpedia_summary(m, page)
    s = dbpedia_summary(page)
    s = truncate_message(s, 3)
    m.reply(s)
  end

  def wikipedia_summary(page)
    bot.loggers.info "Getting wikipedia summary for #{page}"

    url = "http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&redirects=yes&page=#{CGI.escape(page)}"
    bot.loggers.info "Retrieving #{url}"

    file = open(url)
    json = file.read
    h = JSON.parse(json)
    if h['error'] then
      return h['error']['info']
    else
      html = h['parse']['text']['*']
      doc = Nokogiri::HTML(html)
      summary = doc.xpath('//p').first.text
    end

    return summary
  end

  def dbpedia_summary(page)
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
      summary = Nokogiri::HTML(summaries[0].text).text.strip
      return summary
    end
  end

end

end
