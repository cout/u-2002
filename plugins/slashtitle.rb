require 'nokogiri'
require 'open-uri'

module Plugins

class Slashtitle
  include Cinch::Plugin

  match /slashtitle/

  set help: "slashtitle - generate a random slashdot title"

  def execute(m)
    file = open("http://www.bbspot.com/toys/slashtitle")
    html = file.read
    n = Nokogiri::XML("<div>#{html}</div>")

    title = n.xpath('//B').text.strip
    story = n.xpath('//b').text.split("\n")[4]

    m.safe_reply("#{title} - #{story}")
  end
end

end

