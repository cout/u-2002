require 'open3'

class UnitsPlugin
  include Cinch::Plugin

  match /units\s+(.*?)\s+to\s+(.*)/,
        help: "units"

  def execute(m, from, to)
    p from, to
    input, output, error = Open3.popen3('/usr/bin/units -q --verbose')
    begin
      input.puts from
      input.puts to
      output.gets; output.gets # eat input
      m.reply("Units says: #{output.gets.strip}")
    ensure
      input.close
      output.close
    end
  end
end

