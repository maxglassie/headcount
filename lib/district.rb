class District
  attr_accessor :data

  def initialize(hash)
    @data =  hash
  end

  def name
    @data[:name]
  end

end