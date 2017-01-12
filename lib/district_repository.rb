require 'pry'
require "csv"
require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'

class DistrictRepository

  attr_accessor :repository, :relationships

  def initialize(data = {})
    @repository = data
    @relationships = Hash.new
  end

  def load_data(input_file_hash)
    make_category_repositories(input_file_hash)
  end

  def make_category_repositories(input_file_hash)
    unless input_file_hash[:enrollment].nil?
      e = EnrollmentRepository.new
            @relationships[:enrollment] = e
            e.load_data(input_file_hash)
      read_file(input_file_hash[:enrollment][:kindergarten])
    end
    unless input_file_hash[:statewide_testing].nil?
      s = StatewideTestRepository.new
            @relationships[:statewide_testing] = s
            s.load_data(input_file_hash)
    end
    unless input_file_hash[:economic_profile].nil?
      epr = EconomicProfileRepository.new
            @relationships[:economic_profile] = epr
            epr.load_data(input_file_hash)
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
    # binding.pry
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
