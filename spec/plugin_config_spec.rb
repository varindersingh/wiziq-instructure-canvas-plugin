require File.dirname(__FILE__) + '/spec_helper'

module WiziqVC
  describe PluginConfig do   

    it 'should have a valid api url' do
      
      PluginConfig.api_url.should_not be_empty
      (PluginConfig.api_url =~ URI::regexp).should_not be_nil
      
    end

    it 'should have a valid access_key' do
      PluginConfig.access_key.should_not be_empty
    end

    it 'should have a valid secret_key' do
      PluginConfig.secret_key.should_not be_empty
    end

  end

end