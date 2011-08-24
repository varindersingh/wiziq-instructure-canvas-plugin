
Rails::logger.debug "#{ Time.now } Inside wiziq plugin registration module..Start registering wiziq plugin"

Canvas::Plugin.register('wiziq', :web_conferencing, {
  :name => lambda{ t :name, "Wiziq" },
  :description => lambda{ t :description, "Wiziq virtual classroom" },
  :website => 'http://wiziq.com',
  :author => 'Varinder',
  :author_website => 'http://authorgen.com',
  :version => '1.0.0',
  :settings_partial => 'plugins/wiziq_settings',
  :settings => {:time_zone => 'Asia/Kolkata',
                :api_url => 'http://classapi.wiztest.authordm.com/apimanager.ashx',
                :access_key => 'kndxlmt3RJw=',
                :secret_key => 'XxLzvbPUE2D/DFY5osT/6g=='
    }
})


