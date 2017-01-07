require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
  end

  def test_enrollment_repo_exists
    assert_equal EnrollmentRepository, @er.class
  end

  def test_enrollment_creates_new_instance_with_empty_hash_argument
    enrollment = Enrollment.new(Hash.new)
    assert_equal Hash.new, enrollment.data
  end

  def test_enrollment_creates_new_instance_with_data
    enrollment = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal ({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), enrollment.data[:kindergarten_participation]
  end

  def test_er_can_load_csv_file
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    enrollment = @er.repository["COLORADO"]
    assert_equal "COLORADO", enrollment.data[:name]
  end

  def test_find_by_name_returns_nil
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    assert_nil @er.find_by_name("NOT THERE")
  end

  def test_find_by_name_returns_object
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    returned_enrollment = @er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", returned_enrollment.data[:name]
  end

end #class end
