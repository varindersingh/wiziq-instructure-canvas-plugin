module Wiziq

pp =  Canvas::Plugin.register('wiziq', :web_conferencing, {
      :name => lambda{ t :name, "Wiziq" },
      :description => lambda{ t :description, "Wiziq virtual classroom" },
      :website => 'http://wiziq.com',
      :author => 'Varinder',
      :author_website => 'http://authorgen.com',
      :version => '1.0.0',
      :settings_partial => 'plugins/wiziq_settings',
      :settings => {:api_url => 'http://class.api.wiziq.com/'}
    }) #if !Canvas::Plugin.find :wiziq
  Rails::logger.debug "registered plugin #{pp.inspect}"

end
