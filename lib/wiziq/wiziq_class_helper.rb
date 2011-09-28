# Author : Varinder Singh 
# Wiziq Inc
# This file is part of wiziq virtual classroom plugin for Canvas
# Handles the mapping between a web_conference and wiziq class

module Wiziq
  
  class WiziqClassHelper

    attr_accessor :wiziq_conference

    @@attributes ||= []
  
    consts =  ApiConstants::ParamsSchedule.constants

    consts.each do |attr|

      @@attributes << ApiConstants::ParamsSchedule.const_get(attr)
      send :attr_accessor, ApiConstants::ParamsSchedule.const_get(attr)

    end
   
    def get_values_hash
    
      raise "Wiziq_conference attribute is not set." if @wiziq_conference.nil?
    
      hash = Hash.new
      time_now = Time.now.in_time_zone @wiziq_conference.time_zone

      Rails::logger.debug "wiziq_class hash time_zone is #{ @wiziq_conference.time_zone }"

      duration = @wiziq_conference.duration
      duration = 300 if duration > 300
      hash.store ApiConstants::ParamsSchedule::TITLE , @wiziq_conference.title
      hash.store ApiConstants::ParamsSchedule::DURATION , duration
      hash.store ApiConstants::ParamsSchedule::START_DATETIME ,  time_now.strftime("%m/%d/%Y %H:%M:%S %p")
      hash.store ApiConstants::ParamsSchedule::TIMEZONE, @wiziq_conference.time_zone
      hash.store ApiConstants::ParamsSchedule::COURSE_ID , @wiziq_conference.context_id
      hash.store ApiConstants::ParamsSchedule::PRESENTER_ID , @wiziq_conference.user.uuid
      hash.store ApiConstants::ParamsSchedule::PRESENTER_NAME , @wiziq_conference.user.name
    
      Rails::logger.debug "wiziq_class hash is #{ hash.inspect }"
      hash

    end
  end
end