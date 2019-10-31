require 'backends/shared_backend_behaviour'
require 'support/spreadsheet_paths'

RSpec.describe Spreadshot::Backends::SmarterCSVBackend do
  include_examples 'Spreadshot::Backends::ReaderBackend', described_class.new, SpreadsheetPaths::CSV_PATH, SpreadsheetPaths::XLSX_PATH
end