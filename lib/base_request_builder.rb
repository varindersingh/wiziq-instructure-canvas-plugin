module WiziqVC
  
  class BaseRequestBuilder

    include WiziqVC
    include WiziqVC::WiziqApiConstants

    attr_reader :api_method,:api_url,:params_hash,:http_util
    
    def initialize(api_method)
    
      @api_method = api_method
      @api_url = PluginConfig.api_url + %{?#{ ParamsAuth::METHOD }=} + @api_method
      @http_util = HttpUtil.new @api_url
      get_auth_params
    
    end

    def get_auth_params

      #access_key = 'G/CFeRhSLI4='
      #secret_key = 'w8hjAKHP3roadSUZxdUFyQ=='

      #access_key = 'kndxlmt3RJw='
      #secret_key = 'XxLzvbPUE2D/DFY5osT/6g=='
          
      access_key = PluginConfig.access_key
      secret_key = PluginConfig.secret_key
      
      @api_url = PluginConfig.api_url + %{?#{ ParamsAuth::METHOD }=} + @api_method
      
      time_stamp = get_unix_timestamp

      crypto_helper = CryptoHelper.new

      crypto_helper.add_param(ParamsAuth::ACCESS_KEY, access_key)
      crypto_helper.add_param(ParamsAuth::TIMESTAMP, time_stamp)
      signature_base = crypto_helper.add_param(ParamsAuth::METHOD, @api_method)

      auth_base =  AuthBase.new(secret_key,signature_base)

      signature = auth_base.generate_hmac_digest
          
      common_post_params = {

        ParamsAuth::ACCESS_KEY => access_key,
        ParamsAuth::TIMESTAMP  => time_stamp,
        ParamsAuth::SIGNATURE  => signature
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