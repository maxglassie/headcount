
module DataManager

  def location(row)
    row[:location].upcase
  end

  def year(row)
    row[:timeframe].to_i
  end

  def percentage(row)
    if row[:data].to_s.include?("LNE") || row[:data].to_s.include?("N/A")
      row[:data]
    else
      row[:data].to_f
    end
  end

  def category(row)
      row[:score].downcase.to_sym
  end

  def race_ethnicity(row)
    if row[:race_ethnicity].downcase.include?("pacific")
      row[:race_ethnicity].downcase.split("/").last.gsub(" ", "_").to_sym
    else
      row[:race_ethnicity].downcase.gsub(" ", '_').to_sym
    end
  end

end