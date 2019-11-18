require 'spreadshot/backends/reader_backend'

RSpec.describe Spreadshot::Backends::ReaderBackend do
  let(:backend) { BackendWithNoReadMethod.new }
  context 'when extended without overriding #read' do
    it 'raises NotImplementedError when read is called' do
      expect { backend.read('some_path') }
        .to raise_error(NotImplementedError)
    end
  end
end