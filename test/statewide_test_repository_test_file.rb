require 'minitest/autorun'
require 'minitest/pride'
require './lib/enrollment_repository'
require './lib/enrollment'
require './lib/district_repository'
require './lib/statewide_test'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test

def setup
  @str = StatewideTestRepository.new
end

def test_statewide_testing_repository_basics
    @str.load_data({
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
                      :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
                    }
                  })
    simple

    assert str.find_by_name("ACADEMY 20")
    assert str.find_by_name("GUNNISON WATERSHED RE1J")
end

def test_load_data_with_fixtures
  simple = StatewideTestRepository.new
    simple.load_data({
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
                      :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
                    }
                  })
    simple

  st = simple.find_by_name("COLORADO")
  assert_equal "", st.data
end

def test_basic_proficiency_by_grade
  skip
    str = statewide_repo
    expected = { 2008 => {:math => 0.857, :reading => 0.866, :writing => 0.671},
                 2009 => {:math => 0.824, :reading => 0.862, :writing => 0.706},
                 2010 => {:math => 0.849, :reading => 0.864, :writing => 0.662},
                 2011 => {:math => 0.819, :reading => 0.867, :writing => 0.678},
                 2012 => {:math => 0.830, :reading => 0.870, :writing => 0.655},
                 2013 => {:math => 0.855, :reading => 0.859, :writing => 0.668},
                 2014 => {:math => 0.834, :reading => 0.831, :writing => 0.639}
               }

    testing = str.find_by_name("ACADEMY 20")
    expected.each do |year, data|
      data.each do |subject, proficiency|
        assert_in_delta proficiency, testing.proficient_by_grade(3)[year][subject], 0.005
      end
    end
end

# def statewide_repo
#     str = StatewideTestRepository.new
#     str.load_data({
#                     :statewide_testing => {
#                       :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
#                       :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
#                       :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
#                       :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
#                       :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
#                     }
#                   })
#     str
#   end

  # def district_repo
  #   dr = DistrictRepository.new
  #   dr.load_data({:enrollment => {
  #                   :kindergarten => "./data/Kindergartners in full-day program.csv",
  #                   :high_school_graduation => "./data/High school graduation rates.csv",
  #                  },
  #                  :statewide_testing => {
  #                    :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
  #                    :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
  #                    :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
  #                    :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
  #                    :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
  #                  }
  #                })
  #   dr
  # end

  def statewide_repo_fixtures
    simple = StatewideTestRepository.new
    simple.load_data({
                    :statewide_testing => {
                      :third_grade => "./test/fixtures/3rd_grade_proficiency_percentage_fixture_COLORADO.csv",
                      :math => "./test/fixtures/race_ethnicity_math_proficiency_COLORADO.csv"
                    }
                  })
    simple
  end

end