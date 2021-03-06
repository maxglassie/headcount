require_relative 'data_manager'
require_relative 'unknown_data_error'
require_relative 'unknown_race_error'

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
    range = {}
    @data[:median_household_income].each do |key, value|
      range[enumerate_year_interval(key)] = value
    end

    income_array = []
    range.each do |key, value|
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

  def children_in_poverty_district_average
    total = @data[:children_in_poverty].map do |key, value|
      if value.is_a?(Float)
        value
      end
    end
    average = total.compact.reduce(:+) / total.compact.length
    average.to_s[0..4].to_f
  end

  def children_in_poverty_in_year(year)
     if @data[:children_in_poverty].nil?
      raise UnknownDataError
    elsif @data[:children_in_poverty][year].nil?
      raise UnknownDataError
    else
      @data[:children_in_poverty][year]
    end
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    if @data[:free_or_reduced_price_lunch][year][:percentage].nil?
      raise UnknownDataError
    else
      @data[:free_or_reduced_price_lunch][year][:percentage]
    end
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    if @data[:free_or_reduced_price_lunch][year].nil?
      raise UnknownDataError
    elsif @data[:free_or_reduced_price_lunch][year][:total].nil?
      raise UnknownDataError
    else
      @data[:free_or_reduced_price_lunch][year][:total]
    end
  end

  def free_and_reduced_price_lunch_district_average
    total = @data[:free_or_reduced_price_lunch].map do |year, category|
      if category[:percentage]
        category[:percentage]
      end
    end
    average = total.reduce(:+) / total.length
    average.to_s[0..4].to_f
  end

  def title_i_in_year(year)
    if @data[:title_i][year].nil?
      raise UnknownDataError
    else
      @data[:title_i][year]
    end
  end

end
