require 'mock_bot'
require './plugins/coin'

describe Plugins::Coin do
  let!(:bot) { MockBot.new }
  let!(:plugin) { Plugins::Coin.new(bot) }
  let!(:matcher) { Plugins::Coin.matchers[0] }
  let!(:message) { double() }

  describe :match do
    it 'should give nil heads and tails if the string is "coin"' do
      match = matcher.pattern.match "coin"
      match[0].should eq 'coin'
      match[1].should eq nil
      match[2].should eq nil
    end

    it 'should give non-nil heads and tails if they are specified' do
      match = matcher.pattern.match "coin heads ruby rocks tails ruby is awesome"
      match[0].should eq 'coin heads ruby rocks tails ruby is awesome'
      match[1].should eq 'ruby rocks'
      match[2].should eq 'ruby is awesome'
    end
  end

  describe :execute do
    it 'should reply with heads if the flip is 0' do
      plugin.stub!(:rand) { 0 }
      message.should_receive(:reply).with('Flip was heads')
      plugin.execute(message, nil, nil)
    end

    it 'should reply with tails if the flip is 1' do
      plugin.stub!(:rand) { 1 }
      message.should_receive(:reply).with('Flip was tails')
      plugin.execute(message, nil, nil)
    end
  end
end

