require './lib/district_repository'

class HeadcountAnalyst

  def initialize(district_repository)
    @district_repository = district_repository
  end

  def kindergarten_participation_rate_variation(district_name, against_district)
      against_name = against_district[:against]
      # binding.pry
      district_object = @district_repository.find_by_name(district_name)
      against_object = @district_repository.find_by_name(against_name)

      district_percentages = district_object.enrollment.kindergarten_participation_by_year
      against_percentages = against_object.enrollment.kindergarten_participation_by_year

      # find the district's average participation across all years and

      district_averages = district_percentages.values.reduce(:+)/district_percentages.values.count
      against_averages = against_percentages.values.reduce(:+)/against_percentages.count

      # divide it by the average of the state participation data across all years
      result = district_averages/against_averages
      result.round(3)
      # find the district's average participation across all years and
      # binding.pry
      # didvide it by the average of the 'against' district's participation data across all years
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
          # binding.pry
        # else
        #   percentage = "N/A"
        end
      end
      returned_hash

      # if the years match, divide the values of each matching years

    end
end
# district_percentages = @district_repository.repository[state_name].parent_repository.relationships[:enrollment].repository[district_name].data[:kindergarten_participation]
# state_percentages = @district_repository.repository[state_name].parent_repository.relationships[:enrollment].repository[state_name].data[:kindergarten_participation]

# district = @district_repository.find_by_name(district_name)
#
# against_district = @district_repository.find_by_name(against_name)
#
# # pulls the district's enrollment_by_year data (returned as an array)
#   district_years = district.enrollment.kindergarten_participation_by_year
#   against_district_years = against_district.enrollment.kindergarten_participation_by_year
#
#   #calculate the sum of the years
#   district_sum = district_years.reduce(0) do |sum, (year, data)|
#     sum += data
#   end
#
#   against_district_sum = against_district_years.reduce(0) do |sum, (year, data)|
#     sum += data
#   end
#
#   #gets the count of the years for each
#   district_count = district_years.count
#   against_district_count = against_district_years.count
#
#   #finds the averages
#   district_average = district_sum / district_count
#   against_district_average = against_district_sum / against_district_count
#
#   #final rate variation
#   rate_variation = district_average / against_district_average
#   return district_name / against_district_name
