class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_name, against_district)
    #pulls the district objects
    district = @district_repository.find_by_name(district_name)
    against_district = @district_repository.find_by_name(against_district)
    
    #pulls the district's enrollment_by_year data (returned as an array)
    district_years = district.enrollment.kindergarten_participation_by_year
    against_district_years = against_district.enrollment.kindergarten_participation_by_year

    #calculate the sum of the years
    district_sum = district_years.reduce(0) do |sum, (year, data)|
      sum += data
    end

    against_district_sum = against_district_years.reduce(0) do |sum, (year, data)|
      sum += data
    end

    #gets the count of the years for each
    district_count = district_years.count
    against_district_count = against_district_years.count

    #finds the averages
    district_average = district_sum / district_count
    against_district_average = against_district_sum / against_district_count

    #final rate variation
    rate_variation = district_average / against_district_average
    #return district_name / against_district_name
  end

end