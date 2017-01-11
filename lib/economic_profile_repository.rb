require 'pry'
require "csv"
require_relative "economic_profile"
require_relative "data_manager"

class EconomicProfileRepository
  include DataManager
  attr_accessor :repository

  def initialize(data = {})
    @repository = data
    @house_hold = [:median_household_income]
  end

  def load_data(input_file_hash)
    open_file_hash = create_open_file_hash(input_file_hash[:economic_profile])
    hash_of_data_hashes = create_data_hash_dispatcher(open_file_hash)
    build_repository(hash_of_data_hashes)
  end

  def create_open_file_hash(input_file_hash)
    open_file_hash = {}
    input_file_hash.each do |key, value|
        open_file_hash[key] = open_file(value)
     end
     open_file_hash
  end

  def create_data_hash_dispatcher(open_file_hash)
    hash_of_data_hashes = {}
    open_file_hash.each do |key, value|
      if @house_hold.include?(key)
          hash_of_data_hashes[key] = median_household_create_data_hash(value)
      end
    end
    hash_of_data_hashes
  end

  def populate_repository(data_hash)
      data_hash.each do |district, data|
        if @repository[district.upcase] == nil
          @repository[district.upcase] = EconomicProfile.new({:name => district.upcase})
        end
    end
  end

  def add_data_to_repository_objects(key, data_hash)
    data_hash.each do |district, data|
      r = @repository[district.upcase]
      r.add_data(key, data)
    end
  end

  def build_repository(hash_of_data_hashes)
    populate_repository(hash_of_data_hashes[:median_household_income])
    hash_of_data_hashes.each do |key, value|
      add_data_to_repository_objects(key, value)
    end
  end

  def open_file(file_name)
    CSV.open(file_name,
                      headers: true,
                      header_converters: :symbol)
  end

  def median_household_create_data_hash(csv)
      returned_hash = {}

      csv.each do |row|
        name = location(row)
        year = year(row)
        data = percentage(row)
        category = category(row)
          if returned_hash[name].nil?
            returned_hash[name] = {}
            returned_hash[name][year] = {category => data}
          elsif returned_hash[name][year].nil?
            returned_hash[name][year] = {category => data}
          else returned_hash[name][year][category].nil? 
            returned_hash[name][year] = returned_hash[name][year].merge({category => data})
          end
      end
      returned_hash
  end

  # def race_ethnicity_create_data_hash(csv)
  #     returned_hash = {}

  #     csv.each do |row|
  #       name = location(row)
  #       year = year(row)
  #       data = percentage(row)
  #       category = race_ethnicity(row)
  #         if returned_hash[name].nil?
  #           returned_hash[name] = {}
  #           returned_hash[name][year] = {category => data}
  #         elsif returned_hash[name][year].nil?
  #           returned_hash[name][year] = {category => data}
  #         else returned_hash[name][year][category].nil?
  #           returned_hash[name][year] = returned_hash[name][year].merge({category => data})
  #         end
  #     end
  #     returned_hash
  # end

  def find_by_name(name)
    @repository[name.upcase]
  end

end
