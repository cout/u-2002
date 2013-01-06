require 'spec_helper'
require 'mock_bot'
require './plugins/coin'

describe Plugins::Coin do
  let!(:bot) { MockBot.new }
  let!(:plugin) { Plugins::Coin.new(bot) }
  let!(:matcher) { Plugins::Coin.matchers[0] }
  let!(:message) { double() }

  describe :match do
    it 'should give nil heads and tails if the string is "coin"' do
      expect_match(
          'coin',
          1 => nil,
          2 => nil)
    end

    it 'should give non-nil heads and tails if they are specified' do
      expect_match(
          'coin heads ruby rocks tails ruby is awesome',
          1 => 'ruby rocks',
          2 => 'ruby is awesome')
    end
  end

  describe :execute do
    it 'should reply with heads if the flip is 0' do
      plugin.stub!(:rand) { 0 }
      expect_reply 'Flip was heads'
      plugin.execute(message, nil, nil)
    end

    it 'should reply with tails if the flip is 1' do
      plugin.stub!(:rand) { 1 }
      expect_reply 'Flip was tails'
      plugin.execute(message, nil, nil)
    end
  end
end

