require 'yajl'
require 'json-compare'

module JsonUtilities
# compares two json objects (Array, Hash, or String to be parsed) for equality
  def self.compare_json(json1, json2)

    #old, new = Yajl::Parser.parse(json1), Yajl::Parser.parse(json2)
    JsonCompare.get_diff(json1, json2)

  end
end
