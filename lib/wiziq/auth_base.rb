# Author : Varinder Singh
module Wiziq

  class AuthBase
  
    require 'openssl'
    require 'base64'

    attr_reader :secret_key,:signature_base
  
    def initialize(secret_key,signature_base)

      Rails::logger.debug " init Auth BAse *****************************************************"

      @secret_key = secret_key
      @signature_base = signature_base

    end

    def generate_hmac_digest
    
      Rails::logger.debug "Entered AuthBase.generate_hmac_digest ---- signature is #{ @signature_base }"

      raise "Signature base is not set" if @signature_base.nil?
        

      Rails::logger.debug "Signature base is #{@signature_base} ******************************************************"

      #hmac_sign = HMAC::SHA1::digest( Base64.decode64(secret_key), hmac_base)

      hmac_sign = HMAC::SHA1.digest(CGI::escape(@secret_key), @signature_base)

      hmac_digest = Base64.encode64(hmac_sign)

      Rails::logger.debug "Time stamp =  \r\n HmacBase = #{@signature_base} \r\n Hmac Sign = #{hmac_sign}  \r\n Hmac Digest = #{hmac_digest} "

      hmac_digest.gsub!(/\n/, "")

    end
        
  end
end