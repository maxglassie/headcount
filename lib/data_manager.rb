
module DataManager

  def location(row)
    row[:location].upcase
  end

  def year(row)
    row[:timeframe].to_i
  end

  def percentage(row)
    row[:data].to_f
  end

  def category(row)
    row[:score].downcase.to_sym
  end

  def race_ethnicity(row)
    row[:race_ethnicity].downcase.gsub(" ", '_').to_sym
  end

end