require_relative 'district_repository'

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
        returned_hash[year] = (percentage/against_percentages[year]).to_s[0..4].to_f
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
                                                .enrollment.graduation_rate_by_year
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
    mapped = across.map { |district| kindergarten_participation_against_high_school_graduation(district) }
                   .reduce(:+)
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
    #creates high_graduation_high_poverty result set object
  end

  def creates_result_set_object
    #creates result set object
    #asks for two lists
    #one of all result entry objects representing matching districts
    #method - create_result_entry_objects_from_districts
    #one just the result set object that is the statewide average
    #returns result set object
    
    #needs statewide_average_result_set_object
    #needs array of result entry objects
    #asks result set to add data
  end

  def create_result_entry_objects_from_districts
    #make sure to include name
    #takes hash
    #returns array of result entry objects
    #uses district.enrollment.district_average method
    #and assigns to hash
  end

  def create_statewide_average_result_entry_object
    #uses statewide average methods below
  end

  def districts_matching_high_poverty_high_school_graduation
    #iterates through dr, returns districts that match predicate
    #reusable
    #stores in a hash / or array? of districts organized by name
    #use reject?
    returned = []
    @district_repository.repository.each do |name, district|
        if name == "COLORADO"
          returned << district
        elsif high_poverty_and_high_school_graduation?(district)
          returned << district
        else
          returned
        end
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
