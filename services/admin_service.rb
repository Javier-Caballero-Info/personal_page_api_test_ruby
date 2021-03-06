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

  def self.education_path(lang)
    "/%s/educations" % lang
  end

  def self.portfolio_path(lang)
    "/%s/portfolios" % lang
  end

  def self.research_path(lang)
    "/%s/researches" % lang
  end

  def self.scholastic_path(lang)
    "/%s/scholastic" % lang
  end

  def self.social_network_path(lang)
    "/%s/social-networks" % lang
  end

  def self.work_path(lang)
    "/%s/works" % lang
  end

end