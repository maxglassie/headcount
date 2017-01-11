require 'pry'
require "csv"
require_relative "district"
require_relative "enrollment_repository"
require_relative "statewide_test_repository"

class DistrictRepository

  attr_accessor :repository, :relationships


  def initialize(data = {})
    @repository = data
    @relationships = Hash.new
  end

  def load_data(input_file_hash)
    make_category_repositories(input_file_hash)
    input_file_hash.each_value do |value|
     value.each_value do |file|
       read_file(file)
     end
   end
  end

  def make_category_repositories(input_file_hash)
    input_file_hash.each do |key, value|
          if input_file_hash[key] == :enrollment
            e = EnrollmentRepository.new
            @relationships[:enrollment] = e
            e.load_data(input_file_hash)
          elsif input_file_hash[key] == :statewide_testing
            s = StatewideTestRepository.new
            @relationships[:statewide_testing] = s
            s.load_data(input_file_hash)
          else input_file_hash[key] == :economic_profile
            epr = EconomicProfileRepository.new
            @relationships[:economic_profile] = epr
            epr.load_data(input_file_hash)
          end
    end
  end

  def read_file(file_name)
    contents = CSV.open(file_name,
                        headers: true,
                        header_converters: :symbol)
      contents.each do |row|
        name = row[:location].upcase
            if @repository[name] == nil
                @repository[name] = District.new({:name => name}, self)
            end
      end
  end

  def find_by_name(name)
    @repository[name.upcase]
  end

  def find_all_matching(string)
    matching = []
    @repository.each_pair do |key, value|
      if key.include?(string)
        matching.push(value)
      end
    end
    matching
  end

end
