require 'pry'
require "csv"
require "./lib/enrollment"

class EnrollmentRepository

  attr_accessor :repository

  def initialize(data = {})
    @repository = data
  end

   def load_data(data_file_hash)
    data_file_hash.each_value do |value|
      #may have to match the key value and handle differently - create a repo
      #this is interesting logic, will need to be abstracted to a different method
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
        # binding.pry
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
