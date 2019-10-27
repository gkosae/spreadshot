require 'smarter_csv'

module Spreadshot
  module Backends
    class SmarterCSVBackend < ReaderBackend
      def initialize(options = {})
        options ||= {}
        options[:headers] = true
        super(options)
      end

      def read(path_to_spreadsheet)
        SmarterCSV.process(path_to_spreadsheet) do |row|
          current_row_data = row.first
          yield(@current_row_index, current_row_data)
          @current_row_index += 1
        end
      rescue => e
        raise Spreadshot::ReaderError, e.message
      end
    end
  end
end