ENV["RAILS_ENV"] = 'test'
require 'spec'
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
Dir[File.expand_path(File.dirname(__FILE__) + '/../../../..') + '/spec/factories/*.rb'].each {|file|
    require file
}

def factory_with_protected_attributes(ar_klass, attrs, do_save = true)
  obj = ar_klass.respond_to?(:new) ? ar_klass.new : ar_klass.build
  attrs.each { |k,v| obj.send("#{k}=", attrs[k]) }
  obj.save! if do_save
  obj
end


require 'test_help'