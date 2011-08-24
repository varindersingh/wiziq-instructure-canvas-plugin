# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'canvas'
require 'wiziq'
require 'web_conference'

include WiziqApiConstants

class WiziqConference < WebConference

  attr_reader :time_zone,:attendee_url,:presenter_url

  def admin_join_url(user, return_to="http://www.instructure.com")
    
    join_wiziq_conference    
    @presenter_url

  end

  def participant_join_url(user, return_to="http://www.instructure.com")

    logger.debug 'WiziqConference # participant_join_url entered'
    join_wiziq_conference_as_attendee(user)
    
  end

  def conference_status

    logger.debug 'wiziq_conference  getting conerence status'
    logger.debug " self.conference_key is = #{ self.conference_key }"

    aglive_com = AgliveComUtil.new(ApiMethods::LIST)
    begin

      class_status = aglive_com.get_wiziq_class_status(self.conference_key)
      return :active if class_status["time_to_start"] == "-1" and class_status["status"] == 'upcoming'
      return :closed
    rescue
      :closed
    end

  end

  def join_wiziq_conference

    logger.debug " join_wiziq_conference ,,,, self.conference_key.blank? = #{ self.conference_key.blank?  }  "

    get_class_presenter_info if !self.conference_key.blank? or schedule_wiziq_class

  end


  # This method has been overridden for following reasons.

  # 1. To suppress wiziq class status check from API
  #    while scheduling as there is no need to call
  #    API in this case and status must be 'closed'
  #
  # 2. To force launch of wiziq class as admin even if class status is active
  #    In other words class presenter can always relaunch class as presenter


  def craft_url(user=nil,session=nil,return_to="http://www.instructure.com")
    logger.debug "calling craft url in wiziq_conference"
    user ||= self.user
    initiate_conference and touch or return nil
    if (user == self.user || self.grants_right?(user,session,:initiate)) #&& !active?(true)
      admin_join_url(user, return_to)
    else
      participant_join_url(user, return_to)
    end
  end


  def add_attendee_to_wiziq_session(user)

    begin

      aglive_com = AgliveComUtil.new(ApiMethods::ADDATTENDEE)
      add_attendee_hash = aglive_com.add_attendee_to_session(self.conference_key, user.uuid, user.name)
      add_attendee_hash["attendee_url"]

    rescue => e
      #self.flash_notice = "There was an error adding attendee to session"
      Rails::logger.debug "Error adding attendee #{ e.inspect }"
    end

  end

  def get_class_presenter_info

    logger.debug "Entered get_class_presenter_info"

    return if !@presenter_url.blank?

    Rails::logger.debug " Getting info already scheduled class get_class_presenter_info #{ self.conference_key } "


    aglive_com = AgliveComUtil.new(ApiMethods::LIST)
    class_presenter_info = aglive_com.get_class_presenter_info(self.conference_key)
    @presenter_url = class_presenter_info["presenter_url"]

  end

  def join_wiziq_conference_as_attendee(user)

    get_class_attendee_info or add_attendee_to_wiziq_session(user)

  end

  def get_class_attendee_info

    Rails::logger.debug " Getting attendee info already scheduled class  "

    aglive_com = AgliveComUtil.new(ApiMethods::LIST)
    class_attendee_info = aglive_com.get_class_attendee_info(self.conference_key)
    return false if class_attendee_info.blank?
    class_attendee_info["attendee_url"]

  end

  def schedule_wiziq_class

    Rails::logger.debug " scheduling class now...conference key is not set }"

    @time_zone = config[:time_zone]

    begin

      aglive_com = AgliveComUtil.new(ApiMethods::SCHEDULE)

      logger.debug " got instance of aglive_com #{  aglive_com }  self.class in initial is #{ self }"

      schedule_response_hash = aglive_com.schedule_class(self)

      @presenter_url  = schedule_response_hash["presenters"][0]["presenter_url"]

      self.conference_key = schedule_response_hash["class_id"]

      save

      Rails::logger.debug " agcom pr url is  #{ schedule_response_hash.inspect }"
        
      true
    rescue => e

      Rails::logger.debug " initiate_conference rescue  #{ e.inspect }"

      false
    end

  end

  private :add_attendee_to_wiziq_session,:join_wiziq_conference

end

