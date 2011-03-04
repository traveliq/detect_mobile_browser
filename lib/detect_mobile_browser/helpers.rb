module DetectMobileBrowser
  module Helpers

    def mobile_device?
      return session[:mobile] unless session[:mobile].nil?
      request.mobile_device?
    end

    def mobile_domain?
      !!(request.host =~ /^(m|iphone|android)\./)
    end

    def demobilize_url(url)
      url.gsub(/(http.?:\/\/)(m|iphone|android)\./, '\1www.')
    end

    def mobilize_url(url)
      url.gsub(/(http.?:\/\/)www\./, '\1m.')
    end

    def oldschool_browser?
      return session[:oldschool] unless session[:oldschool].nil?
      mobile_device? && request.oldschool_browser?
    end

    def no_mobile_link
      demobilize_url(current_url_with_nomobile_option(true))
    end

    def yes_mobile_link
      mobilize_url(current_url_with_nomobile_option)
    end

    def current_url_with_nomobile_option(value = nil)
      uri = URI.parse(URI.escape(request.url))
      uri.query = value ? {'nomobile' => value}.to_query : nil
      uri.path = ''
      uri.to_s
    end

    def iphone?
      mobile_device? && request.mobile_device =~ /iphone/i
    end

    def ipod?
      mobile_device? && request.mobile_device =~ /ipod/i
    end

    def android?
      mobile_device? && request.mobile_device =~ /android/i
    end
  end
  
end
