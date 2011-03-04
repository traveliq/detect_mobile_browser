# encoding: utf-8
require File.join(File.dirname(__FILE__), '/lib/detect_mobile_browser')
require File.join(File.dirname(__FILE__), '/lib/detect_mobile_browser/request')
require File.join(File.dirname(__FILE__), '/lib/detect_mobile_browser/helpers')

if defined?(ActionController)

  require 'action_controller/cgi_process'
  require 'action_controller/request'

  if defined?(ActionController::CgiRequest)
    ActionController::CgiRequest.send :include, DetectMobileBrowser::Request
  end

  if defined?(ActionController::Request)
    ActionController::Request.send :include, DetectMobileBrowser::Request
  end

  if Rails.env == "test"
    require 'action_controller/test_process'
    ActionController::TestRequest.send :include, DetectMobileBrowser::Request
  end

  ActionController::Base.send       :include, DetectMobileBrowser::Helpers

  class ActionController::Base
    before_filter :set_mobile_debug_session

    protected

    def set_mobile_debug_session
      [:oldschool, :mobile].each do |debug|
        case params[debug]
        when 'true'
          session[debug] = true
        when 'false'
          session[debug] = false
        when 'disable'
          session[debug] = nil
        end
      end
      logger.debug "DetectMobile: Client has user agent: #{request.env['HTTP_USER_AGENT']}"
      logger.debug "DetectMobile: Client is mobile_device?: #{mobile_device?}. Really ? #{request.mobile_device?}."
      logger.debug "DetectMobile: Client is oldschool_browser?: #{oldschool_browser?}. Really ? #{request.oldschool_browser?}."
      logger.debug "DetectMobile: Client is which mobile_device: #{request.mobile_device}"
      true
    end
  end
end

if defined?(ActionView)
  ActionView::Base.send :include, DetectMobileBrowser::Helpers
end