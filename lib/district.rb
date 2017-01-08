class District
  attr_accessor :data

  def initialize(hash, parent_repository = nil)
    @data =  hash
    @parent_repository = parent_repository
  end

  def name
    @data[:name]
  end

  def enrollment
    @parent_repository.relationships[:enrollment].find_by_name(self.data[:name])
  end

end