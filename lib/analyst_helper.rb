require_relative "headcount_analyst"

module AnalystHelper

  def create_result_entry_array_from_districts(selected_districts_hash)
      result_entry_array = selected_districts_hash.map do |name, district|
        create_result_entry_object(district)
        end
  end

  def create_result_entry_object(district)
    district_name = district.name
    median_household = district
                                      .economic_profile
                                      .median_household_income_average
    child_poverty = district
                            .economic_profile
                            .children_in_poverty_district_average
    free_lunch = district
                        .economic_profile
                        .free_and_reduced_price_lunch_district_average
    high_school_graduation = district
                                              .enrollment
                                              .high_school_graduation_district_average
    ResultEntry.new({
        name: district_name,
        free_and_reduced_price_lunch_rate: free_lunch,
        children_in_poverty_rate: child_poverty,
        high_school_graduation_rate: high_school_graduation,
        median_household_income: median_household
                                })
  end

  def create_statewide_average_result_entry_object
    district_name = "STATEWIDE AVERAGE"
    median_household = median_household_income_statewide_average
    child_poverty = children_in_poverty_statewide_average
    free_lunch = free_and_reduced_price_lunch_statewide_average
    high_school_graduation = high_school_graduation_statewide_average

    ResultEntry.new({
        name: district_name,
        free_and_reduced_price_lunch_rate: free_lunch,
        children_in_poverty_rate: child_poverty,
        high_school_graduation_rate: high_school_graduation,
        median_household_income: median_household
                                })
  end

  def districts_matching_high_poverty_high_school_graduation
    selected_districts = @district_repository.repository.select do |name, district|
        unless name == "COLORADO"
           high_poverty_and_high_school_graduation?(district)
        end
      end
  end

  def districts_matching_high_income_disparity
     selected_districts = @district_repository.repository.select do |name, district|
        unless name == "COLORADO"
           high_income_disparity?(district)
        end
      end
  end

  def high_income_disparity?(district)
    income = median_household_income_above_statewide_average?(district)
    children_in_poverty = children_in_poverty_above_statewide_average?(district)

    if income && children_in_poverty
      true
    else
      false
    end
  end

  def high_poverty_and_high_school_graduation?(district)
    free_lunch = free_lunch_above_statewide_average?(district) 
    children_in_poverty = children_in_poverty_above_statewide_average?(district)
    graduation = high_school_graduation_above_statewide_average?(district)

    if free_lunch && children_in_poverty && graduation
      true
    else
      false
    end
  end

  def district_greater_than_statewide_average(district_average, statewide_average)
    if district_average > statewide_average
      true
    else
      false
    end
  end

  def free_lunch_above_statewide_average?(district)
   district_average = district
                                .economic_profile
                                .free_and_reduced_price_lunch_district_average
    statewide_average = free_and_reduced_price_lunch_statewide_average

    district_greater_than_statewide_average(district_average, statewide_average)
  end

  def children_in_poverty_above_statewide_average?(district)
    district_average = district
                                .economic_profile
                                .children_in_poverty_district_average
    statewide_average = children_in_poverty_statewide_average

    district_greater_than_statewide_average(district_average, statewide_average)
  end

  def high_school_graduation_above_statewide_average?(district)
    district_average = district
                                .enrollment
                                .high_school_graduation_district_average
    statewide_average = high_school_graduation_statewide_average

    district_greater_than_statewide_average(district_average, statewide_average)
  end

  def median_household_income_above_statewide_average?(district)
    district_average =  district
                                  .economic_profile
                                  .median_household_income_average
    statewide_average = median_household_income_statewide_average

    district_greater_than_statewide_average(district_average, statewide_average)
  end

  def median_household_income_statewide_average
    statewide = @district_repository
                        .find_by_name("COLORADO")
    statewide
    .economic_profile
    .median_household_income_average
  end

  def children_in_poverty_statewide_average
    total = @district_repository.repository.map do |name, district|
        unless name == "COLORADO"
          district
          .economic_profile
          .children_in_poverty_district_average
        end
      end
    average = total.compact.reduce(:+) / total.compact.length
    average.to_s[0..4].to_f
  end

  def free_and_reduced_price_lunch_statewide_average
    statewide = @district_repository
                        .find_by_name("COLORADO")
    statewide
    .economic_profile
    .free_and_reduced_price_lunch_district_average
  end

  def high_school_graduation_statewide_average
    statewide = @district_repository
                        .find_by_name("COLORADO")
    statewide
    .enrollment
    .high_school_graduation_district_average
  end

end