require_relative '../utils/rest_client_library.rb'

module StorageService

  def self.base_path
    ENV['BASE_PATH_STORAGE']
  end

  def self.body_example
    "------WebKitFormBoundary7MA4YWxkTrZu0gWContent-Disposition: form-data; name=\"upload\"; filename=\"IMG_20171203_121714_831.jpg\"Content-Type: image/jpeg------WebKitFormBoundary7MA4YWxkTrZu0gW--"
  end
  
end