require_relative 'district_repository'
require_relative 'result_set'
require_relative 'result_entry'


class HeadcountAnalyst

  def initialize(district_repository)
      @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_name, against_district)
      against_name = against_district[:against]
      district_object = @district_repository
                        .find_by_name(district_name)
      against_object = @district_repository
                        .find_by_name(against_name)
      district_percentages = district_object
                            .enrollment
                            .kindergarten_participation_by_year
      against_percentages = against_object
                            .enrollment
                            .kindergarten_participation_by_year
      district_averages = district_percentages
                          .values
                          .reduce(:+)/district_percentages.values.count
      against_averages = against_percentages
                        .values
                        .reduce(:+)/against_percentages.count
      result = district_averages/against_averages
      result.round(3)
  end

  def kindergarten_participation_rate_variation_trend(district_name, against_district)
    against_name = against_district[:against]
    district_object = @district_repository
                      .find_by_name(district_name)
    against_object = @district_repository
                      .find_by_name(against_name)
    district_percentages = district_object
                          .enrollment
                          .kindergarten_participation_by_year
    against_percentages = against_object
                          .enrollment
                          .kindergarten_participation_by_year
    returned_hash = {}
    district_percentages.each do |year, percentage|
      if against_percentages[year]
        returned_hash[year] = (
        percentage/against_percentages[year]
                              ).to_s[0..4].to_f
      end
    end
    returned_hash
  end

  def kindergarten_participation_against_high_school_graduation(district_name)
    district_object = @district_repository
                              .find_by_name(district_name)
    statewide_object = @district_repository
                              .find_by_name("COLORADO")
    high_school_percentages = district_object
                              .enrollment
                              .graduation_rate_by_year
    kindergarten_percentages = district_object
                              .enrollment
                              .kindergarten_participation_by_year
    statewide_high_school_percentages = statewide_object
                                        .enrollment
                                        .graduation_rate_by_year
    statewide_kindergarten_percentages = statewide_object
                                        .enrollment
                                        .kindergarten_participation_by_year
    high_school_averages = high_school_percentages
                          .values
                          .reduce(:+)/high_school_percentages.values.count
    kindergarten_averages = kindergarten_percentages
                          .values
                          .reduce(:+)/kindergarten_percentages.values.count
    statewide_high_school_averages = statewide_high_school_percentages
                                    .values
                                    .reduce(:+)/statewide_high_school_percentages.values.count
    statewide_kindergarten_averages = statewide_kindergarten_percentages
                                      .values
                                      .reduce(:+)/statewide_kindergarten_percentages.values.count
    kindergarten_variation = kindergarten_averages/statewide_kindergarten_averages
    graduation_variation = high_school_averages/statewide_high_school_averages

    comparison = (kindergarten_variation/graduation_variation).to_s[0..4].to_f

  end

  def kindergarten_participation_correlates_with_high_school_graduation(for_district)
    across = for_district[:across]
    for_name = for_district[:for]
    if for_name
      verify_correlations(for_name)
    else
      verify_mult_correlations(across)
    end
  end

  def kindergarten_participation_against_household_income(district_name)
    district_object = @district_repository
                              .find_by_name(district_name)
    statewide_object = @district_repository
                              .find_by_name("COLORADO")

    district_income_average = district_object
                            .economic_profile
                            .median_household_income_average

    statewide_income_average = statewide_object
                              .economic_profile
                              .median_household_income_average

    kindergarten_percentages = district_object
                              .enrollment
                              .kindergarten_participation_by_year

    statewide_kindergarten_percentages = statewide_object
                                        .enrollment
                                        .kindergarten_participation_by_year

    kindergarten_averages = kindergarten_percentages
                          .values
                          .reduce(:+)/kindergarten_percentages.values.count

    statewide_kindergarten_averages = statewide_kindergarten_percentages
                                      .values
                                      .reduce(:+)/statewide_kindergarten_percentages.values.count
    kindergarten_variation = kindergarten_averages/statewide_kindergarten_averages

    median_income_variation = district_income_average.to_f/statewide_income_average.to_f

    comparison = (kindergarten_variation/median_income_variation).to_s[0..4].to_f
  end

  def kindergarten_participation_correlates_with_household_income(for_district)
    across = for_district[:across]
    for_name = for_district[:for]
    if for_name
      verify_household_correlations(for_name)
    else
      verify_mult_household_correlations(across)
    end
  end

  def verify_household_correlations(for_name)
    if for_name == "STATEWIDE"
      result = kindergarten_participation_against_household_income("COLORADO")
      within_range_for_statewide(result)
    else
      result = kindergarten_participation_against_household_income(for_name)
      within_range(result)
    end
  end

  def verify_mult_household_correlations(across)
    mapped = across.map do |district|
      kindergarten_participation_against_household_income(district)
      end.reduce(:+)
    average = mapped/across.count
    within_range(average)
  end

  def verify_correlations(for_name)
    if for_name == "STATEWIDE"
      result = kindergarten_participation_against_high_school_graduation("COLORADO")
      within_range_for_statewide(result)
    else
      result = kindergarten_participation_against_high_school_graduation(for_name)
      within_range(result)
    end
  end

  def verify_mult_correlations(across)
    mapped = across.map do |district|
      kindergarten_participation_against_high_school_graduation(district)
      end.reduce(:+)
    average = mapped/across.count
    within_range(average)
  end

  def within_range(result)
    if result >= 0.6 && result <= 1.5
      true
    else
      false
    end
  end

  def within_range_for_statewide(result)
    if result > 0.7
      true
    else
      false
    end
  end

  def high_poverty_and_high_school_graduation
    argument = high_poverty_and_graduation_create_result_set_argument
    ResultSet.new(argument)
  end

  def high_income_disparity
    argument = high_income_disparity_create_result_set_argument
    ResultSet.new(argument)
  end

  def high_income_disparity_create_result_set_argument
    district_objects = districts_matching_high_income_disparity
    matching = create_result_entry_array_from_districts(district_objects)
    statewide = create_statewide_average_result_entry_object

    high_school_result_set_argument = {
        matching_districts: matching,
        statewide_average: statewide
                                                              }
  end

  def high_poverty_and_graduation_create_result_set_argument
    district_objects = districts_matching_high_poverty_high_school_graduation
    matching = create_result_entry_array_from_districts(district_objects)
    statewide = create_statewide_average_result_entry_object

    high_school_result_set_argument = {
        matching_districts: matching,
        statewide_average: statewide
                                                              }
  end

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

  def free_lunch_above_statewide_average?(district)
   district_average = district
                                .economic_profile
                                .free_and_reduced_price_lunch_district_average
    statewide_average = free_and_reduced_price_lunch_statewide_average

    if district_average > statewide_average
      true
    else
      false
    end
  end

  def children_in_poverty_above_statewide_average?(district)
    district_average = district
                                .economic_profile
                                .children_in_poverty_district_average
    statewide_average = children_in_poverty_statewide_average

    if district_average > statewide_average
      true
    else
      false
    end
  end

  def high_school_graduation_above_statewide_average?(district)
    district_average = district
                                .enrollment
                                .high_school_graduation_district_average
    statewide_average = high_school_graduation_statewide_average

    if district_average > statewide_average
      true
    else
      false
    end
  end

  def median_household_income_above_statewide_average?(district)
    district_average =  district
                                  .economic_profile
                                  .median_household_income_average
    statewide_average = median_household_income_statewide_average

    if district_average > statewide_average
      true
    else
      false
    end
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
