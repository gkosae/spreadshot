# Spreadshot
A Ruby library for reading spreadsheets with support for multiple backends. This is an attempt to:
  - Provide a uniform interface for reading different formats of spreadsheets.
  - Reduce the amount of code changed when you decide to switch reader backends for any reason

[SmarterCSV](https://github.com/tilo/smarter_csv) (for csv files) and [RubyXL](https://github.com/weshatheleopard/rubyXL) (for xlsx files) backends are provided out of the box.

The name was inspired by the names of [battle chips from Megaman Battle Network 3](https://megaman.fandom.com/wiki/List_of_Mega_Man_Battle_Network_3_Battle_Chips).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'spreadshot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install spreadshot

## Usage

Require gem with:

```ruby
require 'spreadshot'
```

Read spreadsheet with one of the provided backends
```ruby
csv_reader = Spreadshot::Reader.new(backend: :smarter_csv)

begin
  csv_reader.read(path_to_sample_csv_file) do |row_index, row_data|
    puts "#{row_index} - #{row_data}"
  end
rescue Spreadshot::ReaderError
  # Handle error
end

# A cell_index_to_field_mapper must be provided for the RubyXL backend to map values read from a column to a unique key in the yielded hash
xlsx_reader = Spreadshot::Reader.new(
  backend: :ruby_xl,
  cell_index_to_field_mapper: {0 => :h1, 1 => :h2, 2 => :h3, 3 => :h4}
)

begin
  xlsx_reader.read(path_to_sample_xlsx_file) do |row_index, row_data|
    puts "#{row_index} - #{row_data}"
  end
rescue Spreadshot::ReaderError
  # Handle error
end

# SAMPLE OUTPUT
# 2 - {:h1=>11, :h2=>22, :h3=>33, :h4=>44}
# 3 - {:h1=>111, :h2=>222, :h3=>333, :h4=>444}
# 4 - {:h1=>1111, :h2=>2222, :h3=>3333, :h4=>4444}
```

`row_index` begins from 2 because index 1 is used for headers. But if the spreadsheet does not contain headers then the backend can be configured with `headers: false` to begin reading from index 1 (This is only available for the RubyXL backend. To the best of my knowledge SmarterCSV does not support reading files without headers).

```ruby
xlsx_reader = Spreadshot::Reader.new(
  backend: :ruby_xl,
  worksheet_index: 1, # Index of the worksheet to read from (defaults to 0, i.e. the first worksheet)
  headers: false,
  cell_index_to_field_mapper: {0 => :h1, 1 => :h2, 2 => :h3, 3 => :h4}
)
begin
  xlsx_reader.read(path_to_sample_xlsx_file) do |row_index, row_data|
    puts "#{row_index} - #{row_data}"
  end
rescue Spreadshot::ReaderError
  # Handle error
end

# SAMPLE OUTPUT
# 1 - {:h1=>11, :h2=>22, :h3=>33, :h4=>44}
# 2 - {:h1=>111, :h2=>222, :h3=>333, :h4=>444}
# 3 - {:h1=>1111, :h2=>2222, :h3=>3333, :h4=>4444}
```

OR<br/><br/>
Read spreadsheet with a custom backend. The custom backend MUST inherit from `Spreadshot::Backends::ReaderBackend` and override `#read`. `#read` MUST yield the index and content(as a Hash) of each row read.<br/><br/>
Example:
```ruby
class SmarterCSVBackend < Spreadshot::Backends::ReaderBackend
  def initialize(options = {})
    options ||= {}
    options[:headers] = true
    super(options)
  end
      
  def read(path_to_spreadsheet)
    SmarterCSV.process(path_to_spreadsheet) do |row|
      current_row_data = row.first
      yield(@current_row_index, current_row_data)
      @current_row_index += 1
    end
  rescue => e
    raise Spreadshot::ReaderError, e.message
  end
end

csv_backend = Spreadshot::Backends::SmarterCSVBackend.new
csv_reader = Spreadshot::Reader.new(backend: csv_backend)
```

Reader backends can also be switched dynamically with the `#set_backend` method
```ruby
reader = Spreadshot::Reader.new(backend: :smarter_csv)

xlsx = Spreadshot::Backends::RubyXLBackend.new(
  worksheet_index: 0, 
  cell_index_to_field_mapper: {0 => :h1, 1 => :h2, 2 => :h3, 3 => :h4}
)
reader.set_backend(xlsx)

#OR

reader.set_backend(:ruby_xl)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gkosae/spreadshot.git

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
