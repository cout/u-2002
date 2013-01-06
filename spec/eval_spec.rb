require 'mock_bot'
require './plugins/eval'

describe Plugins::Eval do
  let!(:bot) { MockBot.new }
  let!(:plugin) { Plugins::Eval.new(bot) }
  let!(:matcher) { Plugins::Eval.matchers[0] }
  let!(:message) { double() }

  describe :match do
    it 'should give the whole expression' do
      match = matcher.pattern.match "eval 1+1"
      match[0].should eq 'eval 1+1'
      match[1].should eq '1+1'
    end

    it 'should give the whole expression even when there are spaces' do
      match = matcher.pattern.match "eval 1 + 1"
      match[0].should eq 'eval 1 + 1'
      match[1].should eq '1 + 1'
    end
  end

  describe :execute do
    it 'should evaluate the expression' do
      message.should_receive(:reply).with('Result: 2')
      plugin.execute(message, '1+1')
    end
  end
end
