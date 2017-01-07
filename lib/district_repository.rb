require 'pry'
require "csv"
require "./lib/district"

class DistrictRepository

  attr_accessor :repository

  def initialize(data = {})
    @repository = data
  end

#could refactor - move the hash iterator out 
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
    @repository.each do |key, value|
      if key.include?(string.upcase)
        matching << value
      end
    end
    matching
  end

end
