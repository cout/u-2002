require 'yaml'

module Plugins

# Based on the YamlScores plugin, but fixes some bugs
class Score
  include Cinch::Plugin

  set help: "scores - display all scores\n" + \
            "score <user> - show score for <user>\n" + \
            "user +1 - increase score for user\n" + \
            "etc."

  attr_reader :scores

  def initialize(bot, args={})
    super(bot)

    if args[:scores] then
      @scores = args[:scores]
    else
      load_scores()
    end
  end

  def load_scores
    if File.exist?('scores.yaml')
      @scores = YAML.load_file('scores.yaml')
    else
      @scores = {}
    end
  end

  def save_scores
    synchronize(:update) do
      File.open('scores.yaml', 'w') do |fh|
        YAML.dump(@scores, fh)
      end
    end
  end

  def update_score(nick, delta)
    if @scores[nick] then
      @scores[nick] += delta
    elsif prevnick = @scores.keys.find { |n| nick.downcase == n.downcase } then
      @scores[nick] = @scores[prevnick]
      @scores[nick] += delta
      @scores.delete(prevnick)
    else
      @scores[nick] = delta
    end
    save_scores()
  end

  def nickscore(nick)
    score = @scores[nick] || 0
    return "#{nick}(#{score})"
  end

  match(/scores/, method: :scores)
  def scores(m)
    m.reply "Scores: #{@scores.sort_by{|k,v| -v }.map{|k,v| "#{k}: #{v}" }*", "}."
  end

  match(/score (\S+)/, method: :score)
  def score(m, nick)
    if @scores[nick]
      m.reply "Score for #{nick}: #{@scores[nick]}."
    else
      m.reply "No score for #{nick}."
    end
  end

  match(/(\S+) ([-+]1)/,    use_prefix: false, use_suffix: false, method: :change)
  match(/(\S+) ?([-+]{2})/, use_prefix: false, use_suffix: false, method: :change)
  def change(m, nick, score)
    if nick == m.user.nick
      m.reply "You can't score for yourself..."
    elsif nick == bot.nick
      m.reply "You can't score for me..."
    elsif m.channel.has_user?(nick)
      score.sub!(/([+-]){2}/,'\11')
      update_score(nick, score.to_i)
      m.reply "#{nickscore(m.user.nick)} gave #{score} for #{nickscore(nick)}"
    elsif %w( , : ).include?(nick[-1]) && m.channel.has_user?(nick.slice(0..-2))
      nick.slice!(-1)
      score.sub!(/([+-]){2}/,'\11')
      update_score(nick, score.to_i)
      m.reply "#{nickscore(m.user.nick)} gave #{score} for #{nickscore(nick)}"
    elsif
      m.reply "#{nick} is not here"
    end
  end

end

end

