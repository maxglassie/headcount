require 'minitest/autorun'
require 'minitest/pride'
require './lib/district'
require './lib/district_repository'
require 'pry'

class DistrictTest < Minitest::Test

 def test_district_creates_new_instance_with_empty_hash_argument
    district = District.new(Hash.new)
    assert_equal Hash.new, district.data
  end

  def test_district_creates_new_instance_with_name_hash
    district = District.new({:name => "test_name"})
    assert_equal "test_name", district.data[:name]
  end

  def test_name_method_returns_name
    district = District.new({:name => "test_name"})
    assert_equal "test_name", district.name
  end

  def test_district_object_can_access_parent_repo
    dr = DistrictRepository.new
    dr.load_data({
        :enrollment=> {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    district = dr.find_by_name("ACADEMY 20")

    e = district.enrollment

    assert_equal Enrollment, e.class
  end

end
