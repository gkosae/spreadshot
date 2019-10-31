require 'support/fake_backends'

RSpec.describe Spreadshot::Reader do
  context 'when initialized with a provided backend' do
    let(:supported_backend) { {id: :smarter_csv, options: {}} }
    let(:unsupported_backend) { {id: :solarize, options: {}} }

    it 'raises a Spreadshot::BackendNotFoundError if the provided backend is not recognized' do
      expect { 
        Spreadshot::Reader.new(
          backend: unsupported_backend[:id],
          backend_options: unsupported_backend[:options],
        ) 
      }.to raise_error(Spreadshot::BackendNotFound)
    end
    
    it 'creates an instance of Spreadshot::Reader if the provided backend is recognized' do
      reader = Spreadshot::Reader.new(
        backend: supported_backend[:id],
        backend_options: supported_backend[:options],
      ) 

      expect(reader).to be_a(Spreadshot::Reader)
    end
  end
  

  context 'when initialized with a custom backend' do
    let(:valid_backend) { ValidBackend.new }
    let(:invalid_backend) { InvalidBackend.new }

    it 'raises a Spreadshot::BackendNotFoundError if the custom backend is not a kind of Spreadshot:Backends::ReaderBackend' do
      expect { Spreadshot::Reader.new(backend: invalid_backend) }
        .to raise_error(Spreadshot::BackendNotFound)
    end
    
    it 'creates an instance of Spreadshot::Reader if the provided backend is a kind of Spreadshot:Backends::ReaderBackend' do
      expect(Spreadshot::Reader.new(backend: valid_backend))
        .to be_a(Spreadshot::Reader)
    end
  end

  
  context 'when initialized with a valid backend' do
    let(:valid_backend) { ValidBackend.new }

    it 'expects #read to yield control' do
      reader = Spreadshot::Reader.new(backend: valid_backend)

      expect { |b| reader.read('path_to_sample_spreadsheet', &b) }
        .to yield_control
    end
  end

  describe '#set_backend' do
    context 'when given an invalid backend' do
      let(:provided_backend) { {id: :solarize, options: {}} }
      let(:custom_backend) { InvalidBackend.new }

      it 'raises a Spreadshot::BackendNotFound error' do
        expect { 
          Spreadshot::Reader.new(
            backend: provided_backend[:id],
            backend_options: provided_backend[:options],
          ) 
        }.to raise_error(Spreadshot::BackendNotFound)

        expect { Spreadshot::Reader.new(backend: custom_backend) }
          .to raise_error(Spreadshot::BackendNotFound)
      end
    end
  end
end