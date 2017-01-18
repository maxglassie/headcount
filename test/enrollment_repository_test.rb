require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_repository'
require 'pry'

class EnrollmentRepositoryTest < Minitest::Test

  def setup
    @er = EnrollmentRepository.new
    @load_data_hash = {
      :enrollment => {
                :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                }
                          }
  end

  def test_enrollment_repo_exists
    assert_equal EnrollmentRepository, @er.class
  end

  def test_create_open_file_hash
    output = @er.create_open_file_hash(@load_data_hash[:enrollment])

    assert output[:kindergarten]
  end

  def test_create_data_hash_dispatcher
    output = @er.create_open_file_hash(@load_data_hash[:enrollment])
    result = @er.create_data_hash_dispatcher(output)

    expected = {:kindergarten_participation=>
          {"COLORADO"=>{2011=>0.672, 2012=>0.695, 2013=>0.70263, 2014=>0.74118},
          "ACADEMY 20"=>{2011=>0.489, 2012=>0.47883, 2013=>0.48774, 2014=>0.49022},
          "ADAMS COUNTY 14"=>{2011=>1.0, 2012=>1.0, 2013=>0.9983, 2014=>1.0},
          "ADAMS-ARAPAHOE 28J"=>{2011=>0.95, 2012=>0.97359, 2013=>0.9767, 2014=>0.97123},
          "AGUILAR REORGANIZED 6"=>{2011=>1.0, 2012=>1.0, 2013=>1.0, 2014=>1.0},
          "AKRON R-1"=>{2011=>1.0, 2012=>1.0, 2013=>1.0, 2014=>1.0},
          "ALAMOSA RE-11J"=>{2011=>1.0, 2012=>1.0, 2013=>1.0, 2014=>1.0}
          }
                        }
    assert_equal expected, result
  end

  def test_populate_repository
    output = @er.create_open_file_hash(@load_data_hash[:enrollment])
    data_hash = @er.create_data_hash_dispatcher(output)
    @er.populate_repository(data_hash[:kindergarten_participation])

    result = @er

    expected = Enrollment

    assert_equal expected, result.find_by_name("Colorado").class
  end

  def test_add_data_to_repository_objects
    output = @er.create_open_file_hash(@load_data_hash[:enrollment])
    data_hash = @er.create_data_hash_dispatcher(output)
    @er.populate_repository(data_hash[:kindergarten_participation])

    @er.add_data_to_repository_objects(:kindergarten_participation, data_hash[:kindergarten_participation])

    enrollment = @er.find_by_name("COLORADO")
    result = enrollment.kindergarten_participation_in_year(2011)

    assert_equal 0.672, result
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

  def test_enrollment_creates_new_instance_with_name_hash
    enrollment = Enrollment.new({:name => "ACADEMY 20",
                                                    :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal "ACADEMY 20", enrollment.data[:name]
    assert_equal ({2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}), enrollment.data[:kindergarten_participation]
  end

  def test_dr_can_load_csv_file
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    enrollment = @er.repository["Colorado".upcase]
    assert_equal "Colorado".upcase, enrollment.data[:name]
    assert_equal ({2011 => 0.672, 2012 => 0.695, 2013 => 0.70263, 2014 => 0.74118}), enrollment.data[:kindergarten_participation]
  end

  def test_find_by_name_returns_nil
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    assert_nil @er.find_by_name("NOT THERE")
  end

  def test_find_by_name_returns_enrollment
    @er.load_data({
        :enrollment => {
                  :kindergarten => "./test/fixtures/kinder_test_load_data_clean.csv"
                                  }
                            })
    returned_enrollment = @er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", returned_enrollment.data[:name]
  end

  def test_enrollment_repository_loads_two_files
    @er.load_data({
                  :enrollment => {
                    :kindergarten => "./data/Kindergartners in full-day program.csv",
                    :high_school_graduation => "./data/High school graduation rates.csv"
                                            }
                  })
    returned_enrollment = @er.find_by_name("ACADEMY 20")
    assert_equal "ACADEMY 20", returned_enrollment.data[:name]
  end

   def test_high_school_graduation_district_average
    @er.load_data({
                          :enrollment => {
                            :kindergarten => "./data/Kindergartners in full-day program.csv",
                            :high_school_graduation => "./data/High school graduation rates.csv"
                                                    }
                          })
    e = @er.find_by_name("ACADEMY 20")
    result = e.high_school_graduation_district_average
    expected = 0.898

    assert_equal expected, result
  end

end #class end
