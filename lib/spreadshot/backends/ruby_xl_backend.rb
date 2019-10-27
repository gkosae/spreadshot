require 'rubyXL'

module Spreadshot
  module Backends
    class RubyXLBackend < ReaderBackend
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
      end
  
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