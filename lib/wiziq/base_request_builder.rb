module Wiziq
  require 'wiziq/plugin_config'
  require 'wiziq/http_util'
  require 'wiziq/crypto_helper'
  require 'wiziq/auth_base'
  
  class BaseRequestBuilder       
    attr_reader :api_method,:api_url,:params_hash,:http_util
    
    def initialize(api_method)   
      @api_method = api_method     
      @api_url = Wiziq::PluginConfig.new.api_url + %{?#{ ApiConstants::ParamsAuth::METHOD }=} + @api_method     
      @http_util = HttpUtil.new @api_url
      get_auth_params    
    end

    def get_auth_params

      access_key = PluginConfig.new.access_key
      secret_key = PluginConfig.new.secret_key
      time_stamp = get_unix_timestamp
      crypto_helper = CryptoHelper.new
      crypto_helper.add_param( ApiConstants::ParamsAuth::ACCESS_KEY, access_key)
      crypto_helper.add_param( ApiConstants::ParamsAuth::TIMESTAMP, time_stamp)
      signature_base = crypto_helper.add_param( ApiConstants::ParamsAuth::METHOD, @api_method)
      auth_base =  AuthBase.new(secret_key,signature_base)
      signature = auth_base.generate_hmac_digest          
      common_post_params = {
         ApiConstants::ParamsAuth::ACCESS_KEY => access_key,
         ApiConstants::ParamsAuth::TIMESTAMP  => time_stamp,
         ApiConstants::ParamsAuth::SIGNATURE  => signature
      }
      @http_util.add_params(common_post_params)
    end

    def add_params(params={})      
      @http_util.add_params(params)      
    end

    def add_param(key,value)
      @http_util.add_param(key,value)
    end
    
    def send_api_request
      @http_util.send_http_request      
    end
  
    def get_unix_timestamp
      Time.now.to_i
    end  
    private :get_auth_params, :get_unix_timestamp      
  end
end