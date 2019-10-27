module Spreadshot
  class Reader
    def initialize(options)
      set_backend(options[:backend], options[:backend_options])
    end

    def read(path_to_spreadsheet)
      @backend.read(path_to_spreadsheet) {|row_index, row_data| yield(row_index, row_data)}
    end

    def set_backend(backend, backend_options = {})
      @backend = (backend.respond_to?(:read)) ? backend : build_backend(
        backend, 
        backend_options
      )

      raise Spreadshot::BackendNotFound if @backend.nil?
    end

    private
    def build_backend(backend_id, backend_options = {})
      backend_options ||= {}
      return provided_backends[backend_id].call(backend_options)
    rescue NoMethodError
      return nil
    end

    def provided_backends
      {
        smarter_csv: ->(backend_options){ Spreadshot::Backends::SmarterCSVBackend.new(backend_options) },
        ruby_xl: ->(backend_options){ Spreadshot::Backends::RubyXLBackend.new(backend_options) },
      }
    end
  end
end