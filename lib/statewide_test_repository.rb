require 'pry'
require "csv"
require_relative "statewide_test"
require_relative "data_manager"
require_relative "load_data"

class StatewideTestRepository
  include DataManager
  include LoadData
  attr_accessor :repository

  def initialize(data = {})
    @repository = data
    @race_ethnicity = [:math, :reading, :writing]
    @grade = [:third_grade, :eighth_grade]
  end

  def load_data(input_file_hash)
    open_file_hash = create_open_file_hash(input_file_hash[:statewide_testing])
    hash_of_data_hashes = create_data_hash_dispatcher(open_file_hash)
    populate_repository(hash_of_data_hashes[:third_grade])
    build_repository(hash_of_data_hashes)
  end

  def create_data_hash_dispatcher(open_file_hash)
    hash_of_data_hashes = {}
    open_file_hash.each do |key, value|
      if @grade.include?(key)
          hash_of_data_hashes[key] = grade_create_data_hash(value)
      else @race_ethnicity.include?(key)
          hash_of_data_hashes[key] = race_ethnicity_create_data_hash(value)
      end
    end
    hash_of_data_hashes
  end

  def populate_repository(data_hash)
      data_hash.each do |district, data|
        if @repository[district.upcase] == nil
          @repository[district.upcase] = StatewideTest.new({:name => district.upcase})
        end
    end
  end

  def grade_create_data_hash(csv)
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

  def race_ethnicity_create_data_hash(csv)
      returned_hash = {}

      csv.each do |row|
        name = location(row)
        year = year(row)
        data = percentage(row)
        category = race_ethnicity(row)
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

  def find_by_name(name)
    @repository[name.upcase]
  end

end
