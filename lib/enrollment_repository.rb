require 'pry'
require "csv"
require_relative "enrollment"

class EnrollmentRepository

  attr_accessor :repository

  def initialize(data = {})
    @repository = data
  end


  def load_data(data_file_hash)
   read_category_files(data_file_hash)
  end
     #logic that dispatches hashes / files depending on their name / category
      #each file may have to take a different read_file method
  def read_category_files(value)
    value.each_value do |file|
         read_file(file)
       end
  end

  # def create_read_file_method(file, column_header_1, column_name_1, column_header_2, column_header_3)
  # end

  def read_file(file_name)
    contents = CSV.open(file_name,
                        headers: true,
                        header_converters: :symbol)

      enrollment_year_and_value = {}
  #iterate over the e_year_value hash and apply cleaning logic
  #create a method that takes these names as arguments
      contents.each do |row|
        #column_header_1 = row[:column_name_1]
        #column_header_2 = row[:column_name]
        #column_header_3 = row[:column_name]
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
