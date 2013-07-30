require 'nokogiri'
require 'open-uri'

module Plugins

class Protolol
  include Cinch::Plugin

  match /protolol/

  set help: "protolol - grab a random protolol"

  def execute(m)
    file = open("http://protolol.com/random")
    html = file.read
    n = Nokogiri::XML("<div>#{html}</div>")

    joke = n.at_css('.post').at_xpath('text()').text.strip

    m.safe_reply(joke)
  end
end

end

