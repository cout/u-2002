class MockChannel
  attr_reader :bot

  def initialize(bot)
    @bot = bot
    @users = [ ]
  end

  def users=(users)
    @users = users.dup
  end

  def has_user?(user)
    return @users.include?(user)
  end
end

