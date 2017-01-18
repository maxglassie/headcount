require_relative 'unknown_data_error'
require_relative 'unknown_race_error'

class StatewideTest
  attr_accessor :data

  def initialize(data = nil)
    @data = data
    @ethnicity = [:asian, :black, :pacific_islander, 
                      :hispanic, :native_american, 
                      :two_or_more, :white]
    @subjects = [:math, :reading, :writing]
    @grades = [3, 8]
  end

  def name
    @data[:name]
  end

  def add_data(hash_key, input_data)
      if @data[hash_key] == nil
        @data[hash_key] = {}
        @data[hash_key] = input_data
      end
  end

  def proficient_by_grade(grade)
    if grade == 3
      @data[:third_grade]
    elsif grade == 8
      @data[:eighth_grade]
    else
      raise UnknownDataError
    end
  end

  def proficient_by_race_or_ethnicity(race)

      if @ethnicity.include?(race)
        returned_hash = {}
        
        @data.each do |file_tag, year_hash|
          if @subjects.include?(file_tag)
            year_hash.each do |year, race_hash|
                race_hash.each do |race_check, percentage|
                  if race_check == race && returned_hash[year].nil?
                    returned_hash[year] = {file_tag => percentage}
                  elsif race_check == race
                    returned_hash[year] = returned_hash[year].merge({file_tag => percentage})
                  else
                    returned_hash
                  end
               end
           end
          end
        end
      
      else
        raise UnknownRaceError
      end
      returned_hash
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if @subjects.include?(subject)
      if grade == 3
        @data[:third_grade][year][subject]
      elsif grade == 8
        @data[:eighth_grade][year][subject]
      else
        raise UnknownDataError
      end
    end
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    if @subjects.include?(subject) && @ethnicity.include?(race)
      @data[subject][year][race]
    else
      raise UnknownDataError
    end
  end

end