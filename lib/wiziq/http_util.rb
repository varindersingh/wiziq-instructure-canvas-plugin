#Author : Varinder Singh

require 'net/http'

module Wiziq
  class HttpUtil
    attr_reader:request_url,:params_hash
    def initialize(request_url)
      @request_url = request_url
      @params_hash ||= {}
    end  

    def add_params(params={})
      @params_hash = @params_hash.merge! params
    end

    def add_param(key,value)
      @params_hash = @params_hash.merge! Hash[key,value]
    end

    def send_http_request
      uri = URI.parse(@request_url)
      res = nil
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data(@params_hash, '&')
      http = Net::HTTP.new(uri.host, uri.port)
      res = http.start { |htt| htt.request(req)  }                
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
       r = res.body
       Rails::logger.debug "response xml is #{ r }"
       r
      else
        res.error!
      end
    end
  end
end