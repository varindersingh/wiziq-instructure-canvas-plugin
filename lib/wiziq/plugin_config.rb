#Author : Varinder Singh 

module Wiziq
  class PluginConfig   
    def initialize  
      @plugin = Canvas::Plugin.find(:wiziq)
    end   
    def api_url
      @plugin.settings[:api_url]
    end
    def access_key
      @plugin.settings[:access_key]
    end
    def secret_key
      @plugin.settings[:secret_key]
    end
  end
end