require 'minitest/autorun'
require 'fit'

describe Fit::CLI do
  describe "#checkout" do
    it "calls run with the found refname" do
      runner = MiniTest::Mock.new
      runner.expect(:call, nil, ['git checkout foundrefname'])

      cli = Fit::CLI.new
      cli.runner = runner

      cli.stub(:refname_for_substring, 'foundrefname') do
        cli.checkout('query')
      end

      assert runner.verify
    end
  end
end
