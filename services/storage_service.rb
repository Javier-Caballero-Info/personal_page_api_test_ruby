require_relative '../utils/rest_client_library.rb'

module StorageService

  def self.base_path
    ENV['BASE_PATH_STORAGE']
  end
  
end