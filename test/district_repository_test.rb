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

def test_find_by_name_returns_nil
  @dr.load_data({
      :enrollment => {
                :kindergarten => "./data/Kindergartners in full-day program.csv"
                                }
                          })
  assert_nil @dr.find_by_name("NOT THERE")
end

def test_find_by_name_returns_district
  @dr.load_data({
      :enrollment => {
                :kindergarten => "./data/Kindergartners in full-day program.csv"
                                }
                          })
  returned_district = @dr.find_by_name("ACADEMY 20")
  p returned_district
  assert_equal District, returned_district.class
end

def test_find_all_matching_returns_empty_array
  @dr.load_data({
      :enrollment => {
                :kindergarten => "./data/Kindergartners in full-day program.csv"
                                }
                          })
  returned_district = @dr.find_all_matching("ACA")
  binding.pry
  assert_equal District, returned_district.first.class
  #check each key in the repository
  #and see if that key includes the argument ("A")
  #if includes is true
  #return the key's value (which is a district object)
end

def test_find_all_matching_returns_case_insensative_matches


end

end #class end
