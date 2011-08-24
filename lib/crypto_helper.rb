

class CryptoHelper

  attr_reader :signature_base

  def initialize

     @signature_base = ""
     
  end

  def add_param(key,value)

    @signature_base += "&" if !@signature_base.empty?

    @signature_base << key << "=" << value.to_s if !key.nil? && !value.nil?

    @signature_base

  end

end

