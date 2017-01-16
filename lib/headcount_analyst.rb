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

end
