require 'spec_helper'
require 'mock_bot'
require 'mock_channel'
require './plugins/score'

describe Plugins::Score do
  let!(:bot) { MockBot.new }
  let!(:plugin) { Plugins::Score.new(bot, :scores => { }) }
  let!(:message) { double() }
  let!(:channel) { MockChannel.new(bot) }

  before(:each) do
    bot.stub!(:load_scores) { { } }
    bot.stub!(:save_scores) { }
  end


  describe :match do
    it 'should give +1 if the string is "nick +1"' do
      expect_match(
          'nick +1',
          :method => :change,
          1 => 'nick',
          2 => '+1')
    end

    it 'should give -1 if the string is "nick -1"' do
      expect_match(
          'nick +1',
          :method => :change,
          1 => 'nick',
          2 => '+1')
    end

    it 'should give +1 if the string is "nick++"' do
      expect_match(
          'nick++',
          :method => :change,
          1 => 'nick',
          2 => '++')
    end

    it 'should give -1 if the string is "nick--"' do
      expect_match(
          'nick--',
          :method => :change,
          1 => 'nick',
          2 => '--')
    end

    it 'should give +1 if the string is "nick ++"' do
      expect_match(
          'nick ++',
          :method => :change,
          1 => 'nick',
          2 => '++')
    end

    it 'should give -1 if the string is "nick --"' do
      expect_match(
          'nick --',
          :method => :change,
          1 => 'nick',
          2 => '--')
    end
  end

  describe :execute do
    it 'should add one to the score if +1 is passed in' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave +1 for nick(1)'
      plugin.change(message, 'nick', '+1')
    end

    it 'should subtract one to the score if -1 is passed in' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave -1 for nick(-1)'
      plugin.change(message, 'nick', '-1')
    end

    it 'should add one to the score if ++ is passed in' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave +1 for nick(1)'
      plugin.change(message, 'nick', '++')
    end

    it 'should subtract one to the score if -- is passed in' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave -1 for nick(-1)'
      plugin.change(message, 'nick', '--')
    end

    # it 'should give an error if the nick is not in the channel' do
    #   message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
    #   message.stub!(:channel) { channel }
    #   bot.stub!(:nick) { 'botnick' }
    #   channel.users = [ 'nick' ]

    #   expect_reply 'Foo is not here'
    #   plugin.change(message, 'Foo', '+1')
    # end

    it 'should allow scoring for a user without the same capitalization as the nick' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave +1 for Nick(1)'
      plugin.change(message, 'Nick', '+1')
    end

    it 'should treat scores for the same user with different capitalization as the same user' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave +1 for nick(1)'
      plugin.change(message, 'nick', '+1')

      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'Nick' ]

      expect_reply 'othernick(0) gave +1 for Nick(2)'
      plugin.change(message, 'Nick', '+1')
    end

    it 'should update the database with the new capitalization when it changes' do
      message.stub!(:user) { OpenStruct.new(:nick => 'othernick') }
      message.stub!(:channel) { channel }
      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'nick' ]

      expect_reply 'othernick(0) gave +1 for nick(1)'
      plugin.change(message, 'nick', '+1')

      bot.stub!(:nick) { 'botnick' }
      channel.users = [ 'Nick' ]

      expect_reply 'othernick(0) gave +1 for nick(2)'
      plugin.change(message, 'nick', '+1')
    end
  end
end

