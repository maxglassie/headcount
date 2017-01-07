class Enrollment
  attr_accessor :data

  def initialize(hash)
    @data = hash
  end

  def kindergarten_participation_by_year
    stored = {}
    kinder_partiticipation_by_year = @data[:kindergarten_participation]
    kinder_partiticipation_by_year.each { |year,data| stored[year] = data.to_s[0..4].to_f }
    stored
  end

  def kindergarten_participation_by_year

  end

end
