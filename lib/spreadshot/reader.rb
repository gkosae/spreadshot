module Spreadshot
  class Reader
    
    # @param [Hash] options
    # @option options [Symbol, Spreadshot::ReaderBackend] :backend 
    #   The reader backend to use or the id if one of the provided backends
    # @option options [Hash] :backend_options
    #   Required if one of the provided backends is used
    #   * :headers (Boolean) [true] Specifies whether the spreadsheet to be read contains headers. Will be ignored if the backend doesn't provide this option (E.g. SmarterCSV expects headers)
    #   * :worksheet_index (Integer) [0] The index of the worksheet to be read. Used for the RubyXL backend
    #   * :cell_index_to_field_mapper (Hash<Integer, [String, Symbol]>) A hash which maps each cell in a row of the spreadsheet to a key in the result hash created for that row. Must be provided for the RubyXL backend
    #
    # @example
    #   reader = Spreadshot::Reader.new(backend: :smarter_csv)
    #
    #   reader = Spreadshot::Reader.new(backend: :ruby_xl, worksheet_index: 0, cell_index_to_field_mapper: {0 => :H1, 1 => :H2, 2 => :H3, 3 => :H4})
    #
    #   xlsx_backend = Spreadshot::Backends::RubyXLBackend.new(worksheet_index: 0, cell_index_to_field_mapper: {0 => :H1, 1 => :H2, 2 => :H3, 3 => :H4})
    #   reader = Spreadshot::Reader.new(backend: xlsx_backend)
    def initialize(options)
      set_backend(options[:backend], options[:backend_options])
    end




    # Set the backend to use
    #
    # @param [Symbol, Spreadshot::Backends::ReaderBackend] backend 
    #   The new backend or id of one of the provided backends
    # @param [Hash] backend_options
    #   Required if one of the provided backends is used
    # @option backend_options [Boolean] :headers
    #   Specifies whether the spreadsheet to be read contains headers. 
    #   Will be ignored if the backend doesn't provide this option (E.g. SmarterCSV expects headers)
    #   Defaults to true
    # @option backend_options [Integer] :worksheet_index
    #   The index of the worksheet to be read. Used for the RubyXL backend.
    #   Defaults to 0
    # @option backend_options [Hash<Integer, [Symbol, String]>] :cell_index_to_field_mapper
    #   A hash which maps each cell in a row of the spreadsheet to a key in the 
    #   result hash created for that row. Used for the RubyXL backend.
    #   Must be provided
    #
    # @raise [Spreadshot::BackendNotFound]
    #   If no backend is provided or if one of the provided backends is not specified
    #
    # @example
    #   reader = Spreadshot::Reader.new(backend: :ruby_xl, worksheet_index: 0, cell_index_to_field_mapper: {0 => :H1, 1 => :H2, 2 => :H3, 3 => :H4})
    #   csv_backend = Spreadshot::Backends::SmarterCSVBackend.new
    #   reader.set_backend(csv_backend)
    def set_backend(backend, backend_options = {})
      @backend = (backend.is_a?(Spreadshot::Backends::ReaderBackend)) ? backend : build_backend(
        backend,
        backend_options
      )

      raise Spreadshot::BackendNotFound if @backend.nil?
    end




    # Reads data from the specified spreadsheet
    #
    # @param [String] path_to_spreadsheet
    #
    # @yield [row_index, row_data]
    # @yieldparam [Integer] row_index
    #   The index of the current row being read. The first row has an index of 1
    # @yieldparam [Hash] row_data
    #   A hash representation of the data read from the current row
    #
    # @note This method delegates actual reading to the backend
    #
    # @example
    #   reader = Spreadshot::Reader.new(backend: :ruby_xl, worksheet_index: 0, cell_index_to_field_mapper: {0 => :H1, 1 => :H2, 2 => :H3, 3 => :H4})
    #   reader.read('spreadshot_test.xlsx'){|row_index, row_data| puts "#{row_index} - #{row_data}"}
    #   
    #   Sample output
    #   2 - {:H1=>11, :H2=>22, :H3=>33, :H4=>44}
    #   3 - {:H1=>111, :H2=>222, :H3=>333, :H4=>444}
    #   4 - {:H1=>1111, :H2=>2222, :H3=>3333, :H4=>4444}

    def read(path_to_spreadsheet)
      @backend.read(path_to_spreadsheet) {|row_index, row_data| yield(row_index, row_data)}
    end




    private

    # Creates a reader backend using the backend (id) and options/backend_options provided in #initialize or #set_backend
    #
    # @param [Symbol] backend_id the id(key) of the desired backend
    # @param [Hash] backend_options 
    #   options to build the backend with
    # @option backend_options [Boolean] :headers
    #   Specifies whether the spreadsheet to be read contains headers. 
    #   Will be ignored if the backend doesn't provide this option (E.g. SmarterCSV expects headers)
    #   Defaults to true
    # @option backend_options [Integer] :worksheet_index
    #   The index of the worksheet to be read. Used for the RubyXL backend.
    #   Defaults to true
    # @option backend_options [Hash<Integer, [Symbol, String]>] :cell_index_to_field_mapper
    #   A hash which maps each cell in a row of the spreadsheet to a key in the 
    #   result hash created for that row. Used for the RubyXL backend.
    #   Must be provided
    #
    # @return [Spreadshot::Backends::ReaderBackend]
    def build_backend(backend_id, backend_options = {})
      backend_options ||= {}
      return provided_backends[backend_id].call(backend_options)
    rescue NoMethodError
      return nil
    end




    # The provided backends
    # 
    # @return [Hash]
    def provided_backends
      {
        smarter_csv: ->(backend_options){ Spreadshot::Backends::SmarterCSVBackend.new(backend_options) },
        ruby_xl: ->(backend_options){ Spreadshot::Backends::RubyXLBackend.new(backend_options) },
      }
    end
  end
end