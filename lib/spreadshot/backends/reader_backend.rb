module Spreadshot
  module Backends

    # Base class for all spreadshot reader backends.
    class ReaderBackend

      # @param [Hash] options
      # @option options [Boolean] :headers 
      #   Specifies whether the spreadsheet to be read contains headers
      def initialize(options = {})
        options ||= {}
        @headers = (options.has_key?(:headers)) ? options[:headers] : true
        @current_row_index = @headers ? 2 : 1
      end




      # Reads data from the specified spreadsheet
      # @note 
      #   Must be overriden by subclasses.
      #   Override must raise {Spreadshot::ReaderError Spreadshot::ReaderError} if something goes wrong while reading
      #
      #
      # @param [String] path_to_spreadsheet
      #
      # @yield [row_index, row_data]
      # @yieldparam [Integer] row_index 
      #   The index of the current row being read. The first row has an index of 1
      # @yieldparam [Hash] row_data
      #   A hash representation of the data read from the current row
      def read(path_to_spreadsheet)
        raise NotImplementedError
      end
    end
  end
end