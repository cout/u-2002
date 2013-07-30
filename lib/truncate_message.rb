# slightly modified from Cinch's Target#msg
#
# (is this a "substantial" portion of the software?  I don't know...)
#
def message_lines(message)
  text = message.to_s
  split_start = '... '
  split_end   = ' ...'

  lines = [ ]

  text.split(/\r\n|\r|\n/).each do |line|
    maxlength = 440 # too long?
    maxlength_without_end = maxlength - split_end.bytesize

    if line.bytesize > maxlength
      splitted = []

      while line.bytesize > maxlength_without_end
        pos = line.rindex(/\s/, maxlength_without_end)
        r = pos || maxlength_without_end
        splitted << line.slice!(0, r) + split_end.tr(" ", "\u00A0")
        line = split_start.tr(" ", "\u00A0") + line.lstrip
      end

      splitted << line
      splitted[0, (@bot.config.max_messages || splitted.size)].each do |string|
        string.tr!("\u00A0", " ") # clean string from any non-breaking spaces
        lines << string
      end
    else
      lines << line
    end
  end

  return lines
end

def truncate_message(message, max_lines, remove_blanks = true)
  # Convert the message to individual lines
  lines = message_lines(message)
  truncated = false

  # Remove blank lines
  if remove_blanks then
    lines.each { |line| line.chomp! }
    lines.reject { |line| line == "" }
  end

  # Truncate to max_lines number of lines
  if lines.count > max_lines then
    lines = lines[0...max_lines]
    truncated = true
  end

  # Append ellipsis if we truncated
  if truncated then
    lines[-1] += ' ...'
  end

  # Put the lines back together again
  return lines.join("\n")
end
