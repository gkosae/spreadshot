RSpec.shared_examples 'Spreadshot::Backends::ReaderBackend' do |supported_backend, path_to_supported_spreadsheet, path_to_unsupported_spreadsheet|
  let(:backend) { supported_backend }
  let(:path_to_supported_spreadsheet) { path_to_supported_spreadsheet }
  let(:path_to_unsupported_spreadsheet) { path_to_unsupported_spreadsheet }

  describe '#read' do
    context 'when called with the path to a valid and supported spreadsheet' do
      it 'reads contents of the spreadsheet' do
        expect { |b| backend.read(path_to_supported_spreadsheet, &b) }
          .to yield_successive_args(
            [2, {:h1=>11, :h2=>22, :h3=>33, :h4=>44}],
            [3, {:h1=>111, :h2=>222, :h3=>333, :h4=>444}],
            [4, {:h1=>1111, :h2=>2222, :h3=>3333, :h4=>4444}],
          )
      end
    end

    context 'when called with an invalid spreadsheet path or the path to an unsupported spreadsheet' do
      it 'raises a Spreadshot::ReaderError' do 
        expect { backend.read(nil) }.to raise_error(Spreadshot::ReaderError)
        expect { backend.read(path_to_unsupported_spreadsheet) }.to raise_error(Spreadshot::ReaderError)
      end
    end
  end
end