require_relative '../utils/rest_client_library.rb'

module AdminService

  def self.base_path
    ENV['BASE_PATH_ADMIN']
  end

  def self.available_lags
    %w[es en]
  end

  def self.random_lang
    available_lags.sample
  end

  def self.contact_path(lang)
    "/%s/contacts" % lang
  end

end