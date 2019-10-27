module Spreadshot
  module Backends
    class ReaderBackend
      def initialize(options = {})
        options ||= {}
        @headers = (options.has_key?(:headers)) ? options[:headers] : true
        @current_row_index = @headers ? 2 : 1
      end

      def read(path_to_spreadsheet)
        raise NotImplementedError
      end
    end
  end
end