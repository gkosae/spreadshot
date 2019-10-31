require 'backends/shared_backend_behaviour'
require 'support/spreadsheet_paths'

RSpec.describe Spreadshot::Backends::RubyXLBackend do
  context 'when initialized' do
    it 'raises an ArgumentError if no cell_index_to_field_mapper is provided' do
      expect { Spreadshot::Backends::RubyXLBackend.new }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if the cell_index_to_field_mapper provided is not a Hash' do
      expect { Spreadshot::Backends::RubyXLBackend.new(cell_index_to_field_mapper: 0) }
        .to raise_error(ArgumentError)
    end
  end

  cell_index_to_field_mapper = {0 => :h1, 1 => :h2, 2 => :h3, 3 => :h4}
  backend = described_class.new(cell_index_to_field_mapper: cell_index_to_field_mapper)
  include_examples(
    'Spreadshot::Backends::ReaderBackend', 
    described_class.new(cell_index_to_field_mapper: cell_index_to_field_mapper), 
    SpreadsheetPaths::XLSX_PATH, SpreadsheetPaths::CSV_PATH
  )

  let(:backend) { described_class.new(cell_index_to_field_mapper: cell_index_to_field_mapper) }
  let(:cell_index_to_field_mapper) { cell_index_to_field_mapper }
  context 'when initialized with a valid cell_index_to_field_mapper' do
    it 'expects the keys of the hash returned for each row to equal the values of the cell_index_to_field_mapper provided' do
      first_row = nil 
      backend.read(SpreadsheetPaths::XLSX_PATH) do |row_index, row_data|
        first_row = row_data
        break
      end

      expect(first_row.keys).to eq(cell_index_to_field_mapper.values)
    end
  end
  
  context 'when initialized with headers: false' do
    it 'row_index to begin from 1' do
      first_index = nil 
      backend_with_no_headers_config = described_class.new(cell_index_to_field_mapper: cell_index_to_field_mapper, headers: false)
      backend_with_no_headers_config.read(SpreadsheetPaths::XLSX_PATH) do |row_index, row_data|
        first_index = row_index
        break
      end

      expect(first_index).to eq(1)
    end
  end
end