require 'open-uri'
require 'json'
require 'cgi'

module Plugins

class Bible
  include Cinch::Plugin

  match /bible\s+(.*)/

  set help: "bible <book> <chapter>:<verse> [ [version] ]"

  def execute(m, passage)
    if passage =~ /(.*)\[(.*?)\]$/ then
      passage = $1
      version = $2
    else
      version = 'esv'
    end

    passage = passage.capitalize
    version = version.upcase

    if version != 'ESV' then
      m.reply('Sorry, only ESV supported for now')
      return
    end

    text = esv(passage)
    bot.loggers.info "Got: #{text[0..50]}"

    text = truncate_message(text, 3)
    m.reply("#{passage}: #{text} (#{version})")
  end

  def esv(passage)
    params = [
      'key=IP',
      'include-footnotes=false',
      'output-format=plain-text',
      'include-verse-numbers=false',
      'include-passage-references=false',
      'include-first-verse-numbers=false',
      'include-footnotes=false',
      'include-short-copyright=false',
      'include-passage-horizontal-lines=false',
      'include-heading-horizonal-lines=false',
      'include-headings=false',
      'include-subheadings=false',
      'line-length=0',
      "passage=#{CGI.escape(passage)}"
    ]
    url = "http://www.esvapi.org/v2/rest/verse?#{params.join('&')}"

    bot.loggers.info "Retrieving #{url}"
    text = open(url) { |file| file.read }
    return text.strip
  end
end

end

