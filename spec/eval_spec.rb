require 'spec_helper'
require 'mock_bot'
require './plugins/eval'

describe Plugins::Eval do
  let!(:bot) { MockBot.new }
  let!(:plugin) { Plugins::Eval.new(bot) }
  let!(:matcher) { Plugins::Eval.matchers[0] }
  let!(:message) { double() }

  describe :match do
    it 'should give the whole expression' do
      expect_match(
          'eval 1+1',
          1 => '1+1')
    end

    it 'should give the whole expression even when there are spaces' do
      expect_match(
          'eval 1 + 1',
          1 => '1 + 1')
    end
  end

  describe :execute do
    it 'should evaluate the expression' do
      expect_reply 'Result: 2'
      plugin.execute(message, '1+1')
    end
  end
end
