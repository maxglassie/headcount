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
      contents.each do |row|
        name = row[:location].upcase
        year = row[:timeframe].to_i
        data = row[:data].to_f
            #if repo doesn't contain the object, create a new object
            #if repo does contain the object, add the year / data hash
            #to the kindergarten key
            #has to navigate to the kindergarten key and
            #then go another layer deeper to add to the hash
            #it'll need
            if @repository[name] == nil
                @repository[name] = Enrollment.new({:name => name,
                                                                              :kindergarten_participation => {year => data}})
            else
              @repository[name]
              enrollment = @repository[name]
              enrollment.data.each do |key, value|
                    if key == :kindergarten_participation
                      :kindergarten_participation[year] += data
                    end
                  end
            end
      end
  end

end