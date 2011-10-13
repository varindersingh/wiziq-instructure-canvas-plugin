ActiveSupport::Dependencies.autoload_once_paths.reject! { |p| p.index 'vendor/plugins/wiziq' }
Rails.configuration.to_prepare do
    require_dependency 'wiziq/register_plugin'   
    #require_dependency 'wiziq_conference'
    #require_dependency 'web_conference'
  end