
require 'net/http'
require 'rexml/document'


class ResponseData

  include WiziqApiConstants::ResponseNodes 

  attr_reader :doc_root,:api_method,:api_msg,:api_code,:api_status
  attr_accessor :optional_params
  def initialize(response_xml)

    @optional_params = []
    res_doc = REXML::Document.new(response_xml,{:compress_whitespace => :all})
    @doc_root = res_doc.root
    raise 'Invalid api response' if @doc_root.blank?
    @api_status = @doc_root.attributes["status"]
    @api_method = @doc_root.elements["method/text()"]
    @api_msg = @doc_root.elements["error/@msg"] 
    @api_code = @doc_root.elements["error/@code"]
    Rails::logger.debug " api method is  #{ @api_method }"
    

  end  

  # parse response based upon api_method

  
  def parse_schedule_class_response

    hash = Hash.new
    
    class_id = @doc_root.elements["//"+Schedule::CLASS_ID].text
    hash.store(Schedule::CLASS_ID,class_id)
    recording_url = @doc_root.elements["//" + Schedule::RECORDING_URL].text
    hash.store(Schedule::RECORDING_URL,recording_url)
    presenters = []
    @doc_root.elements["//" + Schedule::PRESENTER].each do |presenter|
      
      next if presenter.type == REXML::Text           
      presenters << Hash[
        Schedule::PRESENTER_URL, presenter.elements["//" + Schedule::PRESENTER_URL].text,
        Schedule::PRESENTER_ID, presenter.elements["//" + Schedule::PRESENTER_ID].text
      ]

    end        
    hash.store("presenters",presenters)
    hash    
  end


  def parse_add_attendee_response

    hash = Hash.new
    class_id = @doc_root.elements["//" + AddAttendee::CLASS_ID].text
    hash.store(AddAttendee::CLASS_ID,class_id)
    hash.store(AddAttendee::ATTENDEE_ID, @doc_root.elements["//" + AddAttendee::ATTENDEE_ID].text)
    hash.store(AddAttendee::ATTENDEE_URL, @doc_root.elements["//" + AddAttendee::ATTENDEE_URL].text)
    hash.store(AddAttendee::LANGUAGE , @doc_root.elements["//" + AddAttendee::LANGUAGE].text)
    hash

  end


  def parse_class_info

    hash = Hash.new
    Rails::logger.debug " each debug s  "
    begin
      @optional_params.each do |node|

        Rails::logger.debug " each debug stub  #{ node.type  }  "
        next if node.type == REXML::Text
      
        hash.store(node,@doc_root.elements["//#{ node }"].text)
        Rails::logger.debug " parsing class launch node =>  #{ node }, value => #{ @doc_root.elements["//#{ node }"].text  if !@doc_root.elements["//#{ node }"].blank?  }  "

      end
    rescue
      false
    end
    hash        
  end

  
end
