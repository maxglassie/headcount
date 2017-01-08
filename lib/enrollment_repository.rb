require 'pry'
require "csv"
require_relative "enrollment"

class EnrollmentRepository

  attr_accessor :repository

  def initialize(data = {})
    @repository = data
  end

  def load_data(data_file_hash)
    dispatcher(data_file_hash)
  end

  # def load_data(data_file_hash)
  #   #dispatch on type for incoming hash
  #   #to pass the correct file to the read_file
  #  read_category_files(data_file_hash)
  # end

  def dispatcher(data_file_hash)
    #each statement to apply the logic
    if data_file_hash[:kindergarten]
      kinder = kindergarten_create_data_hash(data_file_hash[:kindergarten])
      create_enrollment_repository(kinder)
    elsif data_file_hash[:high_school_graduation]
      high_school = high_school_create_data_hash(data_file_hash[:high_school_graduation])
      create_enrollment_repository(high_school)
    end
  end
     #logic that dispatches hashes / files depending on their name / category
      #each file may have to take a different read_file method
  # def read_category_files(value)
  #   value.each_value do |file|
  #     #read file method is customized for the given file
  #        read_file(file)
  #      end
  # end

  # def create_read_file_method(file, column_header_1, column_name_1, column_header_2, column_header_3)
  # end

  def kindergarten_create_data_hash(file_name)
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
      enrollment_year_and_value
  end

  #kindergarten_enrollment_year_and_value hash
  #high_school_enrollment_year_and_value hash
  #create a hash of hashes - {kindergarten => kindergarten_enrollment_year hash, 
  #:high_school => high_school_hash}}
  
  # BIG DECISION - create the enrollment repo from a hash of hashes
  # OR - add data from one hash to the existing objects in the repo unless they're nil, in which case create
  # create enrollment object methods that add data to their hash

  def

  def create_enrollment_repository(enrollment_year_and_value)
      enrollment_year_and_value.each do |district, data|
      if @repository[district.upcase] == nil
      @repository[district.upcase] = Enrollment.new({:name => district.upcase, :kindergarten_participation => hash_of_hashes[kindergarten_data], :high_school_graduation => data})
      else @repository[district.upcase] #object is in the repo
        #enrollment object.add_data(:hash_key, data)

  end

  def find_by_name(name)
    @repository[name.upcase]
  end

end
