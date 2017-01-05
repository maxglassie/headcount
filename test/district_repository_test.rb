require 'minitest/autorun'
require 'minitest/pride'
require './lib/district_repository'
require './lib/district'

class DistrictRepositoryTest < Minitest::Test

def setup #operates like initialize
  @dr = DistrictRepository.new
end

def test_district_repo_exists
  assert_equal DistrictRepository, @dr.class
end

def test_district_creates_new_instance_with_empty_hash_argument
  district = District.new(Hash.new)
  assert_equal Hash.new, district.data
end

def test_district_creates_new_instance_with_name_hash
  district = District.new({:name => "test_name"})
  assert_equal "test_name", district.data[:name]
end

def test_dr_can_load_csv_file
  #update this test file and the next so load_data takes a hash
  @dr.load_data({
      :enrollment => {
                :kindergarten => "./data/Kindergartners in full-day program.csv"
                                }
                          })
  district = @dr.repository["Colorado".upcase]
  assert_equal "Colorado".upcase, district.data[:name]
end

def test_dr_can_load_full_csv_file
  skip
  @dr.load_data("./data/Kindergartners in full-day program.csv")
  district = @dr.repository["Colorado".upcase]

  assert_equal "Colorado".upcase, district.data[:name]
end

def test_find_by_name_returns_nil
  skip
  @dr.load_data("./data/Kindergartners in full-day program.csv")
  assert_equal nil, @dr.find_by_name("NOT THERE")
end

def test_find_by_name_returns_district_object
  skip
  @district
end

end #class end