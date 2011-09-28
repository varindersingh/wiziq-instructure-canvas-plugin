#  Wiziq Inc
#  This file is part of wiziq virtual classroom plugin for Canvas

require File.dirname(__FILE__) + '/spec_helper'

module Wiziq

  describe HttpUtil do
    before(:all) do
      puts 'Now running http tests...'
    end

    it 'should be able to communicate with external url over http' do
      puts 'Checking whether wiziq is reachable...'
      util = HttpUtil.new("http://wiziq.com/")
      util.send_http_request rescue false.should == true
    end

  end

end