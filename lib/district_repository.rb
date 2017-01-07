require 'pry'
require "csv"
require_relative "district"

class DistrictRepository

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
      contents.each do |row|
        name = row[:location].upcase
            if @repository[name] == nil
                @repository[name] = District.new({:name => name})
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
