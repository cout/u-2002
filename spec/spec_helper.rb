def expect_reply(reply)
  message.should_receive(:reply).with(reply)
end

