require 'rubyXL'

module Spreadshot
  module Backends

    # Adapter for the RubyXL Gem ({https://github.com/weshatheleopard/rubyXL})
    class RubyXLBackend < ReaderBackend

      # Returns a new instance of RubyXLBackend (See {ReaderBackend#initialize Spreadshot::ReaderBackends::ReaderBackend})
      #
      # @param [Hash] options
      # @option options [Boolean] :headers
      #   Specifies whether the spreadsheet to be read contains headers. 
      #   Defaults to true
      # @option options [Integer] :worksheet_index
      #   The index of the worksheet to be read. Used for the RubyXL backend.
      #   Defaults to 0
      # @option options [Hash] :cell_index_to_field_mapper
      #   A hash which maps each cell in a row of the spreadsheet to a key in the
      #   hash created for that row. Must be provided
      #
      # @raise [ArgumentError] if cell_index_to_field_mapper option is not provided
      # @raise [ArgumentError] if cell_index_to_field_mapper option is not a Hash
      def initialize(options = {})
        options ||= {}
        super(options)

        begin
          @worksheet_index = Integer(options[:worksheet_index])
        rescue TypeError
          @worksheet_index = 0
        end
        
        @cell_index_to_field_mapper = Hash(options[:cell_index_to_field_mapper])
        raise ArgumentError, 'cell_index_to_field_mapper cannot be empty' if @cell_index_to_field_mapper.empty?
        raise ArgumentError, 'cell_index_to_field_mapper is invalid' unless @cell_index_to_field_mapper.is_a?(Hash)
      end
      



      # Reads data from the specified spreadsheet
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
        worksheet = RubyXL::Parser.parse(path_to_spreadsheet)[@worksheet_index]
        headers = @headers
  
        worksheet.each do |row|
          if headers
            headers = false
            next
          end
    
          cell_index = 0
          current_row_data = {}  
    
          row && row.cells.each do |cell|
            val = cell && cell.value
    
            if @cell_index_to_field_mapper[cell_index]
              current_row_data[@cell_index_to_field_mapper[cell_index]] = val
            end
    
            cell_index += 1
          end
          
          yield(@current_row_index, current_row_data)
          @current_row_index += 1
        end
  
        return nil
      rescue Zip::Error => e
        raise Spreadshot::ReaderError, e.message
      end
    end
  end
end