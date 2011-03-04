module DetectMobileBrowser
  module Request

    def mobile_device?
      ua = env['HTTP_USER_AGENT']
      !ua.nil? && !!((ua[0...4] =~ DetectMobileBrowser::OTHER_JEEJAHS) || ua =~ DetectMobileBrowser::NAMED_JEEJAHS)
    end

    def mobile_device
      return nil unless mobile_device?
      if((matched = env['HTTP_USER_AGENT'].scan(DetectMobileBrowser::NAMED_JEEJAHS)).empty?)
        nil
      else
        matched.first.downcase
      end
    end

    def oldschool_browser?
      ua = env['HTTP_USER_AGENT']
      mobile_device? && !!(ua !~ DetectMobileBrowser::NEWSCHOOLS)
    end

  end

end