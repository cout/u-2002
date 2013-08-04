require 'open-uri'
require 'json'
require 'cgi'

module Plugins

class Etymonline
  include Cinch::Plugin

  match /etym\s+(.*)/

  set help: "etym <term>"

  def execute(m, term)
    text = etym(term)
    bot.loggers.info "Got: #{text[0..50]}"

    text = etym(term)
    m.reply(text)
  end

  def etym(term)
    url = "http://www.etymonline.com/index.php?term=#{CGI.escape(term)}"

    bot.loggers.info "Retrieving #{url}"
    file = open(url)
    html = Nokogiri::HTML(file)

    result = html.css('#dictionary').text.strip
    lines = result.split("\n")

    lines = [ "#{lines[0].strip} - #{lines[1]}" ] + lines[2..-1]

    text = lines.join("\n")
    text = truncate_message(text, 2) { "... (More at #{url})" }

    return text
  end
end

end

