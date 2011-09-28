#Author : Varinder Singh 
#  Wiziq Inc
#  This file is part of wiziq virtual classroom plugin for Canvas

module Wiziq
  class PluginConfig
    Rails::logger.debug "PluginConfig init here......"
    def initialize
    begin
    @plugin = Canvas::Plugin.find(:wiziq)
    rescue => e
      Rails::logger.debug "@@plugin init error:  #{ e }"
    end
    end
    #Rails::logger.debug "@@plugin is #{ @@plugin  }  "
   # class << self
      def api_url
        @plugin.settings[:api_url]
      end
      def access_key
        @plugin.settings[:access_key]
      end
      def secret_key
        @plugin.settings[:secret_key]
      end      
    #end
  end
end