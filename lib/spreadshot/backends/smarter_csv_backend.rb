require 'smarter_csv'

module Spreadshot
  module Backends

    # Adapter for the SmarterCSV Gem ({https://github.com/tilo/smarter_csv})
    class SmarterCSVBackend < ReaderBackend

      # Returns a new instance of SmarterCSVBackend (See {ReaderBackend#initialize Spreadshot::ReaderBackends::ReaderBackend})
      # @param [Hash] options
      # @note Ignores :header option
      def initialize(options = {})
        options ||= {}
        options[:headers] = true
        super(options)
      end
      



      # Reads data from the specified CSV file
      # (See {ReaderBackend#read Spreadshot::ReaderBackends::ReaderBackend})
      #
      # @param [String] path_to_spreadsheet
      #
      # @yield [row_index, row_data]
      # @yieldparam [Integer] row_index 
      #   The index of the current row being read. The first row has an index of 1
      # @yieldparam [Hash] row_data
      #   A hash representation of the data read from the current row
      #
      # @raise [Spreadshot::ReaderError]
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