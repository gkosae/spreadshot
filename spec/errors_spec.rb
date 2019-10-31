RSpec.describe Spreadshot::SpreadshotError do
  it "keeps previous error's backtrace if raised after another error" do
    error = begin
      original_exception = Exception.new
      original_exception.set_backtrace(%W[ foo bar baz ])
      raise original_exception
    rescue Exception
      raise Spreadshot::SpreadshotError.new("test") rescue $!
    end

    expect(error.backtrace).to eq(%W[ foo bar baz ])
  end
end