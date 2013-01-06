def expect_match(str, expected)
  match = matcher.pattern.match(str)
  match[0].should eq str
  expected.each do |idx, e|
    match[idx].should eq(e), "match failed at index #{idx}"
  end
end

def expect_reply(reply)
  message.should_receive(:reply).with(reply)
end

