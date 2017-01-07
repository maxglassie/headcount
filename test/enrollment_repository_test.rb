require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test

def setup #operates like initialize
  @dr = EnrollmentRepository.new
end

def test_enrollment_repo_exists
  # skip
  assert_equal EnrollmentRepository, @dr.class
end

def test_enrollment_creates_new_instance_with_empty_hash_argument
  # skip
  enrollment = Enrollment.new(Hash.new)
  assert_equal Hash.new, enrollment.data
end

def test_enrollment_creates_new_instance_with_name_hash
  # skip
  enrollment = Enrollment.new({:name => "ACADEMY 20",
                                                  :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
  assert_equal "ACADEMY 20", enrollment.data[:name]
  assert_equal ({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), enrollment.data[:kindergarten_participation]
end

def test_dr_can_load_csv_file
  # skip
  @dr.load_data({
      :enrollment => {
                :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                }
                          })
  enrollment = @dr.repository["Colorado".upcase]
  assert_equal "Colorado".upcase, enrollment.data[:name]

  assert_equal ({2011 => 0.672, 2012 => 0.695, 2013 => 0.70263, 2014 => 0.74118}), enrollment.data[:kindergarten_participation]
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

def test_find_by_name_returns_enrollment
  skip
  @dr.load_data({
      :enrollment => {
                :kindergarten => "./data/Kindergartners in full-day program.csv"
                                }
                          })
  returned_enrollment = @dr.find_by_name("ACADEMY 20")
  assert_equal "ACADEMY 20", returned_enrollment.data[:name]
end

end #class end


