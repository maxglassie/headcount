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

  def test_enrollment_creates_new_instance_with_name_hash
    enrollment = Enrollment.new({:name => "test_name"})
    assert_equal "test_name", enrollment.data[:name]
  end

  def test_dr_can_load_csv_file
    #update this test file and the next so load_data takes a hash
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    enrollment = @er.repository["COLORADO"]
    assert_equal "COLORADO", enrollment.data[:name]
  end

  def test_find_by_name_returns_nil
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    assert_nil @er.find_by_name("NOT THERE")
  end

  def test_find_by_name_returns_enrollment
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    returned_enrollment = @er.find_by_name("ACADEMY 20")
    p returned_enrollment
    assert_equal Enrollment, returned_enrollment.class
  end

  def test_find_all_matching_returns_empty_array
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./data/Kindergartners in full-day program.csv"
                                  }
                            })
    returned_enrollment = @er.find_all_matching("ACA")
    # binding.pry
    assert_equal Enrollment, returned_enrollment.first.class
    #check each key in the repository
    #and see if that key includes the argument ("A")
    #if includes is true
    #return the key's value (which is a enrollment object)
  end

end #class end
