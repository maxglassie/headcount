require_relative "data_manager"

class EconomicProfile
  include DataManager
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
    range_hash = {}
    @data[:median_household_income].each do |key, value|
      range_hash[enumerate_year_interval(key)] = value
    end

    income_array = []
    range_hash.map do |key, value|
      if key.include?(year)
        income_array << value
      end
    end

    income_array.reduce(:+) / income_array.length
  end

  def median_household_income_average
    total = @data[:median_household_income].map do |key, value|
      value
    end
    total.reduce(:+) / total.length
  end

  def children_in_poverty_in_year(year)

  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if @data[:free_or_reduced_price_lunch][year][:percentage].nil?
      return "UnknownDataError"
    else
      @data[:free_or_reduced_price_lunch][year][:percentage]
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if @data[:free_or_reduced_price_lunch][year].nil? 
      return "UnknownDataError"
    elsif @data[:free_or_reduced_price_lunch][year][:total].nil?
      return "UnknownDataError"
    else
      @data[:free_or_reduced_price_lunch][year][:total]
    end
  end

  def title_i_in_year(year)
    if @data[:title_i][year].nil?
      return "UnknownDataError"
    else
      @data[:title_i][year]
    end
  end

end