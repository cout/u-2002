def expect_match(str, expected)
  method = expected.delete(:method)

  plugin.class.matchers.each do |matcher|
    match = matcher.pattern.match(str)
    if match then
      matcher.method.should eq method if method
      expected.each do |idx, e|
        match[idx].should eq(e),
        "match failed at index #{idx} (expected #{e} but got #{match[idx]})"
      end
      return
    end
  end

  fail "#{str} did not match any patterns"
end

def expect_reply(reply)
  message.should_receive(:reply).with(reply)
end

