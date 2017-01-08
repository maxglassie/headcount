require 'pry'
require "csv"
require_relative "enrollment"

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
        year = row[:timeframe].to_i
        data = row[:data].to_f
        if enrollment_year_and_value[name].nil?
          enrollment_year_and_value[name] = {}
          enrollment_year_and_value[name][year] = data
        else
          enrollment_year_and_value[name][year] = data
        end
      end

      enrollment_year_and_value.each do |district, data|
      @repository[district.upcase] = Enrollment.new({:name => district.upcase, :kindergarten_participation => data})
      end
  end

  def find_by_name(name)
    @repository[name.upcase]
  end

end
