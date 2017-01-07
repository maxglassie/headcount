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
    @dr.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    district = @dr.repository["Colorado".upcase]
    assert_equal "Colorado".upcase, district.data[:name]
  end

  def test_find_by_name_returns_nil
    skip
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
    assert_equal "ACADEMY 20", returned_district.data[:name]
  end

  def test_find_all_matching_districts
    @dr.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    returned_district = @dr.find_all_matching("CA")
    assert_equal "CALHAN RJ-1", returned_district[1].data[:name]
  end

  def test_find_all_matching_districts_canned_data
      d1 = District.new({:name => "ADAMS"})
      d2 = District.new({:name => "ACADEMY 20"})
      dr = DistrictRepository.new({"ADAMS" => d1, "ACADEMY 20" => d2})

      assert_equal d1, dr.find_by_name("Adams")
      assert_equal d2, dr.find_by_name("ACADEMY 20")
  end

end #class end


