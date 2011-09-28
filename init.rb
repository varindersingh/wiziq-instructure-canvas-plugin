
Rails.configuration.to_prepare do
    require_dependency 'wiziq/register_plugin'
    require_dependency 'canvas'
    require_dependency 'wiziq'
    require_dependency 'wiziq_conference'
    require_dependency 'web_conference'
  end