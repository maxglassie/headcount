require 'pry'
require "csv"
require "./lib/enrollment"

class EnrollmentRepository

  attr_accessor :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(data_file_hash)
    data_file_hash.each_value do |value|
     value.each_value do |file|
       read_file(file)
     end
   end
end

  def read_file(file_name)
    contents = CSV.open(file_name,
                        headers: true,
                        header_converters: :symbol)

      enrollment_year_and_value = {}

      contents.each do |row|
        name = row[:location]
        year = row[:timeframe]
        data = row[:data]
        if enrollment_year_and_value[name].nil?
          # make a key value pair with the name and a hash with the timeframe
          enrollment_year_and_value[name] = {}
        else
          # add year and data for that district to it's hash
          enrollment_year_and_value[name][year] = data
        end
      end
        # binding.pry
      enrollment_year_and_value.each do |district,data|
      @repository[district.upcase] = Enrollment.new({:name => district.upcase, :kindergarten_participation => data})
      end
  end

  def find_by_name(name)
    @repository[name.upcase]
  end

  def find_all_matching(string)
    matching = []
    @repository.each_pair do |k,v|
      # binding.pry
      if k.include?(string)
        matching.push(v)
      end
    end
    matching
  end

end
