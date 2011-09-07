
config = YAML::load(File.open(File.join(File.dirname(__FILE__),'../config/wiziq.yml')))

Canvas::Plugin.register('wiziq', :web_conferencing, {
  :name => lambda{ t :name, "Wiziq" },
  :description => lambda{ t :description, "Wiziq virtual classroom" },
  :website => 'http://wiziq.com',
  :author => 'Varinder',
  :author_website => 'http://authorgen.com',
  :version => '1.0.0',
  :settings_partial => 'plugins/wiziq_settings',
  :settings => {:time_zone => 'Asia/Kolkata',
    :api_url => config["api_url"],
    :access_key => config["access_key"],
    :secret_key => config["secret_key"],
    }
})


