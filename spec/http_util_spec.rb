#  Wiziq Inc
#  This file is part of wiziq virtual classroom plugin for Canvas

require File.dirname(__FILE__) + '/spec_helper'

module WiziqVC

  describe HttpUtil do

    it 'should be able to communicate with external url over http' do
      util = HttpUtil.new("http://wiziq.com/")
      util.send_http_request rescue false.should == true
    end

  end

end