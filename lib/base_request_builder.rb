
class BaseRequestBuilder

  include WiziqApiConstants

  attr_reader :api_method,:api_url,:params_hash

  def initialize(api_method)
    
    @api_method = api_method
    @params_hash = get_auth_params
    
  end  

  def get_auth_params

    #access_key = 'G/CFeRhSLI4='
    #secret_key = 'w8hjAKHP3roadSUZxdUFyQ=='

    #access_key = 'kndxlmt3RJw='
    #secret_key = 'XxLzvbPUE2D/DFY5osT/6g=='

    plugin = Canvas::Plugin.find(:wiziq)
    access_key = plugin.settings[:access_key]
    secret_key = plugin.settings[:secret_key]
    temp_url = plugin.settings[:api_url]

    Rails::logger.debug " get_auth_params #{ @api_url }"

    @api_url = temp_url + %{?#{ ParamsAuth::METHOD }=} + @api_method

    Rails::logger.debug " readdddd #{ Canvas::Plugin.find(:wiziq).settings.class }"      

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

    common_post_params

  end

  def add_params(params={})
          
    @params_hash = @params_hash.merge! params

  end

  def add_param(key,value)

    @params_hash = @params_hash.merge! Hash[key,value]

  end


  def send_api_request

    @params_hash.each do |key,val|

      Rails::logger.debug "param  #{ key } =>  #{ val }"

    end

    raise 'api_url is should not be empty' if @api_url.blank?

    uri = URI.parse(@api_url)
    res = nil          
          
    path = uri.path

    Rails::logger.debug "path is ============= #{path}  "
    Rails::logger.debug "uri is =======  #{uri}"

    req = Net::HTTP::Post.new(uri.request_uri)

    req.set_form_data(@params_hash, '&')

    http = Net::HTTP.new(uri.host, uri.port)

    res = http.start { |htt| htt.request(req)  }

    Rails::logger.debug "Request path is ==   #{req.path} ************************************************"

    req.body.each do |key|

      Rails::logger.debug "\r\n #{key} = #{req.body[key]} ***********************************************************************"

    end

    req.each do |key,value|
      Rails::logger.debug "  #{key} = #{value} "
    end
   
    res.each_header do |key,value|
      Rails::logger.debug "  #{key} = #{value} "
    end
    Rails::logger.debug "Request object is #{req.to_hash}"    


    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      Rails::logger.debug "Api resopnse \r\n #{res.body}"
      res.body
    else
      res.error!
    end

  end

  
  def get_unix_timestamp

    Time.now.to_i

  end
  
  private :get_auth_params, :get_unix_timestamp
      
end
