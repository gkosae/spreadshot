require 'spreadshot/version'
require 'spreadshot/backends/reader_backend'
require 'spreadshot/backends/ruby_xl_backend'
require 'spreadshot/backends/smarter_csv_backend'
require 'spreadshot/reader'

module Spreadshot
  class SpreadshotError < StandardError
    def initialize(*args)
      super(*args)
      set_backtrace($!.backtrace) if $!
    end
  end

  class BackendNotFound < SpreadshotError; end
  class ReaderError < SpreadshotError; end
end
