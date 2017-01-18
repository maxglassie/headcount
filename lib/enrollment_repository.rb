require "csv"
require_relative "enrollment"
require_relative "data_manager"

class EnrollmentRepository
  include DataManager
  attr_accessor :repository

  def initialize(data = {})
    @repository = data
  end

  def load_data(input_file_hash)
    open_file_hash = create_open_file_hash(input_file_hash[:enrollment])
    hash_of_data_hashes = create_data_hash_dispatcher(open_file_hash)
    build_repository(hash_of_data_hashes)
  end

  def create_open_file_hash(input_file_hash)
    open_file_hash = {}
    input_file_hash.each do |key, value|
      # binding.pry
        open_file_hash[key] = open_file(value)
     end
     open_file_hash
  end

  def create_data_hash_dispatcher(open_file_hash)
    hash_of_data_hashes = {}
    open_file_hash.each do |key, value|
      if key == :kindergarten
          hash_of_data_hashes[:kindergarten_participation] = kindergarten_create_data_hash(value)
      else key == :high_school_graduation
          hash_of_data_hashes[key] = highschool_create_data_hash(value)
      end
    end
    hash_of_data_hashes
  end

  def populate_repository(data_hash)
      data_hash.each do |district, data|
        if @repository[district.upcase] == nil
          @repository[district.upcase] = Enrollment.new({:name => district.upcase})
        end
    end
  end

  def add_data_to_repository_objects(key, data_hash)
    data_hash.each do |district, data|
      # binding.pry
      e = @repository[district.upcase]
      e.add_data(key, data)
    end
  end

  def build_repository(hash_of_data_hashes)
    populate_repository(hash_of_data_hashes[:kindergarten_participation])
    hash_of_data_hashes.each do |key, value|
      # binding.pry
      add_data_to_repository_objects(key, value)
    end
  end

  def open_file(file_name)
    CSV.open(file_name,
                      headers: true,
                      header_converters: :symbol)
  end

  def kindergarten_create_data_hash(csv)
      returned_hash = {}

      csv.each do |row|
        name = location(row)
        year = year(row)
        data = percentage(row)
          if returned_hash[name].nil?
            returned_hash[name] = {}
            returned_hash[name][year] = data
          else
            returned_hash[name][year] = data
          end
      end
      returned_hash
  end

  def highschool_create_data_hash(csv)
      returned_hash = {}

      csv.each do |row|
        name = location(row)
        year = year(row)
        data = percentage(row)
          if returned_hash[name].nil?
            returned_hash[name] = {}
            returned_hash[name][year] = data
          else
            returned_hash[name][year] = data
          end
      end

      returned_hash
  end

  def find_by_name(name)
    @repository[name.upcase]
  end

end
