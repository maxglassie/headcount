class Enrollment
  attr_accessor :data

  def initialize(data = nil)
    @data = data
  end

  def name
    @data[:name]
  end

  def kindergarten_participation_by_year
    stored = {}
    @data[:kindergarten_participation].each do |year, data|
      stored[year] = data.to_s[0..4].to_f
    end
    stored
  end

  def kindergarten_participation_in_year(year)
    @data[:kindergarten_participation][year].to_s[0..4].to_f
  end

  def graduation_rate_by_year
    stored = {}
    @data[:high_school_graduation].each do |year, data|
      stored[year] = data.to_s[0..4].to_f
    end
    stored
  end

  def graduation_rate_in_year(year)
    @data[:high_school_graduation][year].to_s[0..4].to_f
  end

  def high_school_graduation_district_average
    total = @data[:high_school_graduation].map do |key, value|
      if value.is_a?(Float)
        value
      end
    end
    average = total.compact.reduce(:+) / total.length
    average.to_s[0..4].to_f
  end

  def add_data(hash_key, input_data)
      if @data[hash_key] == nil
        @data[hash_key] = {}
        @data[hash_key] = input_data
      end
  end

end
