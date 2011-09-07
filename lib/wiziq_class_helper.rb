# Author : Varinder Singh 
# Wiziq Inc
# This file is part of wiziq virtual classroom plugin for Canvas
# Handles the mapping between a web_conference and wiziq class

module WiziqVC
  
  class WiziqClassHelper

    attr_accessor :wiziq_conference

    @@attributes ||= []
  
    consts =  WiziqApiConstants::ParamsSchedule.constants

    consts.each do |attr|

      @@attributes << WiziqApiConstants::ParamsSchedule.const_get(attr)
      send :attr_accessor, WiziqApiConstants::ParamsSchedule.const_get(attr)

    end
   
    def get_values_hash
    
      raise "Wiziq_conference attribute is not set." if @wiziq_conference.nil?
    
      hash = Hash.new
      time_now = Time.now.in_time_zone @wiziq_conference.time_zone

      Rails::logger.debug "wiziq_class hash time_zone is #{ @wiziq_conference.time_zone }"

      duration = @wiziq_conference.duration
      duration = 300 if duration > 300
      hash.store WiziqApiConstants::ParamsSchedule::TITLE , @wiziq_conference.title
      hash.store WiziqApiConstants::ParamsSchedule::DURATION , duration
      hash.store WiziqApiConstants::ParamsSchedule::START_DATETIME ,  time_now.strftime("%m/%d/%Y %H:%M:%S %p")
      hash.store WiziqApiConstants::ParamsSchedule::TIMEZONE, @wiziq_conference.time_zone
      hash.store WiziqApiConstants::ParamsSchedule::COURSE_ID , @wiziq_conference.context_id
      hash.store WiziqApiConstants::ParamsSchedule::PRESENTER_ID , @wiziq_conference.user.uuid
      hash.store WiziqApiConstants::ParamsSchedule::PRESENTER_NAME , @wiziq_conference.user.name
    
    
      Rails::logger.debug "wiziq_class hash is #{ hash.inspect }"
      hash

    end

  end
end