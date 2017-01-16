
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

  def year_range(row) 
    year_array = row[:timeframe].split('-')
    result = year_array.map do |e|
      e.to_i
    end
  end

  def poverty_level(row)
    row[:poverty_level].downcase.gsub(" ", "_").to_sym
  end

  def number_or_percentage(row)
    if data_format(row) == :number
      row[:data].to_i
    elsif data_format(row) == :percent
       row[:data].to_f
     else
      row[:data]
    end
  end

  def currency(row)
    row[:data].to_i
  end

  def percent_or_total(row)
    if row[:dataformat].downcase.to_sym == :number
      :total
    else row[:dataformat].downcase.to_sym == :percent
      :percentage
    end
  end

  def data_format(row)
    row[:dataformat].downcase.to_sym
  end

end