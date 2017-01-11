require './lib/district_repository'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_name, against_district)
      against_name = against_district[:against]

      district_object = @district_repository.find_by_name(district_name)
      against_object = @district_repository.find_by_name(against_name)

      district_percentages = district_object.enrollment.kindergarten_participation_by_year
      against_percentages = against_object.enrollment.kindergarten_participation_by_year

      district_averages = district_percentages.values.reduce(:+)/district_percentages.values.count
      against_averages = against_percentages.values.reduce(:+)/against_percentages.count

      result = district_averages/against_averages
      result.round(3)
  end

  def kindergarten_participation_rate_variation_trend(district_name, against_district)
    against_name = against_district[:against]
    district_object = @district_repository.find_by_name(district_name)
    against_object = @district_repository.find_by_name(against_name)

    district_percentages = district_object.enrollment.kindergarten_participation_by_year
    against_percentages = against_object.enrollment.kindergarten_participation_by_year

    returned_hash = {}
      district_percentages.each do |year, percentage|
        if against_percentages[year]
          returned_hash[year] = (percentage/against_percentages[year]).to_s[0..4].to_f
        end
      end
    returned_hash
    end
    
  end
