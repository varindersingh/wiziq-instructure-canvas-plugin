#Author : Varinder Singh 
#  Wiziq Inc
#  This file is part of wiziq virtual classroom plugin for Canvas

module WiziqVC
  class PluginConfig
    @@plugin = Canvas::Plugin.find(:wiziq)     
    class << self

      def api_url
        @@plugin.settings[:api_url]
      end
      def access_key
        @@plugin.settings[:access_key]
      end
      def secret_key
        @@plugin.settings[:secret_key]
      end      
    end
  end
end