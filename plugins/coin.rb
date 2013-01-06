module Plugins

class Coin
  include Cinch::Plugin

  match /coin(?:\s+heads\s+(.*?)\s+tails\s+(.*))?$/

  set help: "coin - flip a coin"

  def execute(m, heads, tails)
    flip = rand(2) == 0 ? "heads" : "tails"

    reply = "Flip was #{flip}"

    if heads or tails then
      if flip == 'heads' then
        reply << "; looks like #{heads}"
      else
        reply << "; looks like #{tails}"
      end
    end

    m.reply(reply)
  end
end

end

