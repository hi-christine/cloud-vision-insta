require 'json'

class Histogram

  attr_accessor :entries, :entry_count, :entryset_count
  def initialize(default_key = 'description')
    @default_key = default_key
    @entries = {}
    @entries.default = 0
    @entry_count = 0
    @entryset_count = 0
  end

  def append_all(entry_array)
    entry_array.each do |e|
      append(e)
    end
    @entryset_count += 1
  end

  def append(entry)
    if entry.class == Hash
      @entries[entry[@default_key]] += 1
    else
      @entries[entry.public_send(@default_key)] += 1
    end
    @entry_count += 1
  end

  def sorted_results
    @entries.sort_by {|k, v| -v}
  end

  def to_json(*_args)
    { 'entry_count' => @entry_count, 'entryset_count' => @entryset_count, 'entries' => entries }.to_json
  end

end
