require 'pry'
require "csv"
require "./lib/district"

class DistrictRepository

  attr_accessor :repository

  def initialize
    @repository = Hash.new
  end

  def load_data(data_file_hash)
    data_file_hash.each do |key, value|
      file_list = value.values.map do |file_name|
        file_name
      end
    end
    binding.pry
    
    file_list.each do |file|
      read_file(file)
    #need an enumerable that moves through the hash
    #and feeds the file_name (from the hash value)
    #to the read_file method
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

end