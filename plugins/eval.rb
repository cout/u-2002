class EvalPlugin
  include Cinch::Plugin

  match /eval\s+(.*)/

  set help: "eval <expression>"

  def execute(m, expr)
    # Make sure we have a valid expression (for security reasons), and
    # evaluate it if we do, otherwise return an error message
    begin
      if expr =~ /^[-+*\/\d\seE.()]*$/ then
        expr.untaint
        m.reply("Result: #{Kernel::eval(expr)}")
      else
        raise "bad input"
      end
     rescue Exception => detail
       m.reply("Result: Error (#{$!.message})")
    end
  end
end

