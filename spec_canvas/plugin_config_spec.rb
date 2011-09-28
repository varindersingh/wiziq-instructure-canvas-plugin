require File.dirname(__FILE__) + '/spec_helper'

module Wiziq
  describe PluginConfig do
    before(:all) do
      puts 'Now checking plugin configuration...'
      @plugin_config = PluginConfig.new
    end

    it 'should have a valid api url' do
      puts 'Validating api_url...'
       @plugin_config.api_url.should_not be_empty
      (@plugin_config.api_url =~ URI::regexp).should_not be_nil
      
    end

    it 'should have a valid access_key' do
      puts 'Checking access_key...'
       @plugin_config.access_key.should_not be_empty
    end

    it 'should have a valid secret_key' do
      puts 'Checking secret_key...'
       @plugin_config.secret_key.should_not be_empty
    end

  end

end