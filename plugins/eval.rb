require 'bigdecimal'

module Plugins

class Eval
  include Cinch::Plugin

  match /eval\s+(.*)/

  set help: "eval <expression>"

  def execute(m, expr)
    # Make sure we have a valid expression (for security reasons), and
    # evaluate it if we do, otherwise return an error message
    begin
      if expr =~ /^[-+*\/\d\seE.()]*$/ then
        expr.untaint
        m.reply("Result: #{format(Kernel::eval(expr))}")
      else
        raise "bad input"
      end
     rescue Exception => detail
       m.reply("Result: Error (#{$!.message})")
    end
  end

  # Quick-and-dirty formatting function that limits the number of characters in the result
  def format(x)
    case x
    when Bignum, BigDecimal
      f = BigDecimal.new(x)
      m, e = f.to_s('E').split('E')
      s = "#{m[0..300]}e#{e}"
    else
      s = x.to_s
    end

    if s.length > 350 then
      return "#{s}<truncated>"
    else
      return s
    end
  end
end

end

