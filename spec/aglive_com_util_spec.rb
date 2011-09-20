
require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/aglive_com_util'
require File.dirname(__FILE__) + '/../app/models/wiziq_conference'

module WiziqVC

  include WiziqVC::WiziqApiConstants
  
  describe AgliveComUtil do

    before(:all) do    
      puts 'Now testing api methods...'
      @class_hash = {
              
        WiziqApiConstants::ParamsSchedule::TITLE => "Wiziq_test_spec_class",
        WiziqApiConstants::ParamsSchedule::START_DATETIME => Time.now.strftime("%m/%d/%Y %H:%M:%S %p"),
        WiziqApiConstants::ParamsSchedule::TIMEZONE => "Asia/Kolkata",
        WiziqApiConstants::ParamsSchedule::DURATION => 60,
        WiziqApiConstants::ParamsSchedule::DESCRIPTION => " This class is scheduled during test case run.",
        WiziqApiConstants::ParamsSchedule::COURSE_ID => "123",
        WiziqApiConstants::ParamsSchedule::PRESENTER_ID => "here_is_test_presenter",
        WiziqApiConstants::ParamsSchedule::PRESENTER_NAME => "presenter_name_test_runner"
      }
      
    end

    it 'should be able to schedule wiziq class using class api' do
      puts 'Scheduling test class on wiziq...'
      aglive = AgliveComUtil.new('create')
      wiziq_class = aglive.schedule_class(@class_hash)
      wiziq_class["class_id"].should_not be_empty
    end

    it 'should return "1009 - class_id is invalid." when adding attendee list for a random class id.' do
      puts 'Trying to add attendee to a non existing wiziq class.Expecting invalid class_id parameter(1009)...'
      aglive = AgliveComUtil.new('add_attendees')
      attendee_res = aglive.add_attendee_to_session(0, "test_attendee_id", "test_screen_name")
      attendee_res["code"].should == 1009
      
    end
  end
end