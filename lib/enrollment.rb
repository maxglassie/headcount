class Enrollment
  attr_accessor :data

  def initialize(hash)
    @data = hash
    # binding.pry
  end

  def kindergarten_participation_by_year
    stored = {}
    kinder_by_year = @data[:kindergarten_participation]
    kinder_by_year.each do |year,data|
      stored[year] = data.to_s[0..4].to_f
    end
      stored
  end
  #
  # def kindergarten_participation_in_year(@data)
  #   # binding.pry
  #   @data
  # end

end
