require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + "/../app/models/wiziq_conference"

module Wiziq

  describe WiziqConference do
    before(:all) do
      PluginConfig.class_eval do
        def api_url
          "http://wiziq.com/"
        end
        def access_key
          "test_access_key"
        end
        def secret_key
          "test_Secret_key"
        end
      end

      WebConference.instance_eval do
        def plugins
          [OpenObject.new(:id => "wiziq", :settings => {:api_url => "http://test.wiziq.com/",:access_key => "test_access_key",:secret_key => "test_secret_key"}, :valid_settings? => true, :enabled? => true)]
        end  
      end
      
      AgliveComUtil.class_eval do
        def schedule_class(opts={})
          {
            "code" => -1,
            "msg" => "",
            "class_id" => "534656",
            "presenters" => [{"presenter_url" => "http://test.canvas.presenter.url",
              "presenter_id" => "http://test.canvas.presenter.id"
            }],
            "recording_url" => "http://recording_url"
          }
        end

        def add_attendee_to_session(class_id,attendee_id,screen_name)
          {
            "code" => -1,
            "msg" => "",
            "class_id" => class_id,
            "attendee_id" => attendee_id,
            "language" => "en-US",
            "attendee_url" => "http://test.attendee.url",
          }
        end

        def get_wiziq_class_status(class_id)
          {
            "code" => -1,
            "msg" => "",
            "status" => "upcoming",
            "time_to_start" => "-1"
          }
        end

        def get_class_presenter_info(class_id)
          {"code" => -1, "msg" => "","presenter_url" => "http://test.presenter_url"}
        end

        def get_class_attendee_info(class_id)
          { "code" => -1, "msg" => "","attendee_url" => "http://test.attendee_url" }
        end
      end
    end

    before(:each) do
      user_model({:time_zone=> "Mountain Time (US & Canada)",:uuid=>"test_user_uuid"})
      email = "test@wiziq.com"
      @user.stub!(:email).and_return(email)      
    end

    context "wiziq" do
      it 'admin join url should not be empty' do
        conference = WiziqConference.create!(:title => "my test conference", :user => @user)
        conference.admin_join_url(@user,"http://www.instructure.com").should_not be_nil
      end
        
      it 'participant join url should not be empty' do
        conference = WiziqConference.create!(:title => "my test conference", :user => @user)
        conference.participant_join_url(@user,"http://www.instructure.com").should_not be_nil
      end

      it "should confirm valid config" do
        WiziqConference.new.valid_config?.should be_true
        WiziqConference.new(:conference_type => "Wiziq").valid_config?.should be_true
      end
    end
  end
end