class EconomicProfile
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end

  def name
    @data[:name]
  end

  def add_data(hash_key, input_data)
      if @data[hash_key] == nil
        @data[hash_key] = {}
        @data[hash_key] = input_data
      end
  end

end