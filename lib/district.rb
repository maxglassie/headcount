class District
  attr_accessor :data

  def initialize(data = nil, parent_repository = nil)
    @data = data
    @parent_repository = parent_repository
  end

  def name
    @data[:name]
  end

  def enrollment
    @parent_repository.relationships[:enrollment]
    .find_by_name(self.data[:name])
  end

  def statewide_test
    @parent_repository.relationships[:statewide_testing]
    .find_by_name(self.data[:name])
  end

  def economic_profile
    @parent_repository.relationships[:economic_profile]
    .find_by_name(self.data[:name])
  end

end
