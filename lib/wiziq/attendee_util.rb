module Wiziq  
  class AttendeeUtil
    attr_reader :attendee_xml
 
    def initialize    
      @attendee_xml ||= %{<attendee_list>}    
    end

    def add_attendee(attendee_id,screen_name)
      @attendee_xml << %{<attendee>}
      @attendee_xml << %{<attendee_id><![CDATA[}  << attendee_id  << %{]]></attendee_id>};
      @attendee_xml << %{<screen_name><![CDATA[}  << screen_name  << %{]]></screen_name>};
      @attendee_xml << %{</attendee>}
    end

    def get_attendee_xml  
      @attendee_xml << %{</attendee_list>}    
    end
  end
end