module WiziqVC
  
  require 'canvas'
  require 'wiziq'

  include WiziqApiConstants

  class AgliveComUtil
  
    attr_reader :api_request,:api_method,:attendee_url

    def initialize(api_method)

      Rails::logger.debug "AgliveComUtil initialize here. Method is #{ api_method }"
    
      #raise 'Unrecognized api_method' if
      @api_method = api_method     
      @api_request = BaseRequestBuilder.new(api_method)
      Rails::logger.debug "AgliveComUtil init. path url is #{ @api_request.api_url  } "

    end


    def schedule_class(wiziq_class_hash)
    
      Rails::logger.debug " self is #{ self.to_s }"

      @api_request.add_params wiziq_class_hash

      Rails::logger.debug "wiziq_conference inspect = #{ wiziq_class_hash.inspect if !wiziq_class_hash.nil?}"
      response_data  = ResponseData.new(@api_request.send_api_request);
      oo = response_data.parse_schedule_class_response
      Rails::logger.debug " schedule class response is #{ oo.inspect if !oo.blank? } "
      oo
    end

    def add_attendee_to_session(class_id,attendee_id,screen_name)

    
      attendee_util = AttendeeUtil.new
      attendee_util.add_attendee(attendee_id, screen_name)

      @api_request.add_params(
        
        ParamsAddAttendee::CLASS_ID => class_id,
        ParamsAddAttendee::ATTENDEE_XML => attendee_util.get_attendee_xml
      )

      response_data = ResponseData.new(@api_request.send_api_request)

      response_data.parse_add_attendee_response
    
    end

    def get_wiziq_class_status(class_id)
       
      get_class_info(class_id, [ListColumnOptions::STATUS,ListColumnOptions::TIME_TO_START])
    
    end

    def get_class_presenter_info(class_id)
    
      get_class_info(class_id, [ListColumnOptions::PRESENTER_URL])

    end

    def get_class_attendee_info(class_id)

      get_class_info(class_id, [ListColumnOptions::ATTENDEE_URL])

    end

    def get_class_info(class_id,columns=[])
    
      @api_request.add_param(ParamsList::CLASS_ID,class_id)
      @api_request.add_param(ParamsList::COLUMNS, columns.join(",")) if !columns.blank?
      response_data = ResponseData.new(@api_request.send_api_request)
      response_data.optional_params = columns
      response_data.parse_class_info

    end

    private :get_class_info
  
  end
end