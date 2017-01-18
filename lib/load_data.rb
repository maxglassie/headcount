module LoadData

  def create_open_file_hash(input_file_hash)
      open_file_hash = {}
      input_file_hash.each do |key, value|
          open_file_hash[key] = open_file(value)
       end
       open_file_hash
  end

  def build_repository(hash_of_data_hashes)
    hash_of_data_hashes.each do |key, value|
      add_data_to_repository_objects(key, value)
    end
  end

  def add_data_to_repository_objects(key, data_hash)
    data_hash.each do |district, data|
      e = @repository[district.upcase]
      e.add_data(key, data)
    end
  end

  def open_file(file_name)
    CSV.open(file_name,
                      headers: true,
                      header_converters: :symbol)
  end

end