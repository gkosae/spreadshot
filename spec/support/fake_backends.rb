require 'spreadshot/backends/reader_backend'

class InvalidBackend; end

class BackendWithNoReadMethod < Spreadshot::Backends::ReaderBackend
end

class ValidBackend < Spreadshot::Backends::ReaderBackend
  def read(path_to_spreadsheet)
    yield(1, {})
  end
end