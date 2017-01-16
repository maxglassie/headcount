class EconomicProfile
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end

  def name
    @data[:name]
  end

  def add_data(hash_key, input_data)
      if @data[hash_key] == nil
        @data[hash_key] = {}
        @data[hash_key] = input_data
      end
  end

  def median_household_income_in_year(year)
    #pull all year data arrays
    #enumerate the interval between those arrays
    #if year is included in that interval
    #put income into an array
    #then find average of those incomes
    
    #create seperate method for enumerating the interval
    #in data manager - returns an array of the years
  end

  def median_household_income_average
    #iterate through all year data arrays
    #grab the income data
    #put it into an array
    #average the array 
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    #grabs year, then percentage data from free_reduce_price lunch
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    #grabs year, then total, returns value
  end

  def title_i_in_year(year)
    #returns percent from year
  end



end