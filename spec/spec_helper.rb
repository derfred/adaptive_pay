require "active_support"

require File.expand_path(File.dirname(__FILE__) + "/../lib/adaptive_pay")
require File.expand_path(File.dirname(__FILE__) + "/rails_mocks")

def decompose(qstr)
  result = {}
  qstr.split("&").each do |f|
    k, v = f.split("=")
    result[k] = v
  end
  result
end
