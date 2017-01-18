class ResultSet
  attr_reader :data

  def initialize(data = {})
    @data = data
  end

  def matching_districts
    @data[:matching_districts]
  end

  def statewide_average
    @data[:statewide_average]
  end

end