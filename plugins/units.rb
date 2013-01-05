require 'open3'

module Plugins

class Units
  include Cinch::Plugin

  match /units\s+(.*?)\s+to\s+(.*)/,
        help: "units"

  set help: "units <from> to <to> - convert units from <from> to <to>\n" + \
            "E.g.: units 5in to cm\n" + \
            "To convert temperature, use: tempF(45) to tempC"

  def execute(m, from, to)
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

end

