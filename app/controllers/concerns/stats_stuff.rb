module StatsStuff
  extend ActiveSupport::Concern

  module ClassMethods
    
  end
  
  module InstanceMethods
    
    def set_reservation_cookie
      return if account_subdomain.blank?
      guid = UUIDTools::UUID.random_create.to_s.gsub("-", "")
      session[:reservation] ||= guid
      cookies[:reservation] ||= {
        value: guid,
        expires: 10.years.from_now,
        domain: "#{account_subdomain}.#{App.domain}"
      }
    end
  
    def user_bug
      session[:reservation]
    end
  
    def store_page_stat
      return if account_subdomain.blank?
      context.hotel ||= hotel_from_subdomain
      Stat.page url: request.url, context: context
    end
    
    def look_to_book!
      Stat.look context: context
    end
    
    def look_to_booked!
      Stat.book context: context
    end
    
    # def mobile?
    #   /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.match(request.user_agent) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.match(request.user_agent[0..3])
    # end
    
    def device_type
      ua = request.user_agent
      o = if ua =~ /GoogleTV|SmartTV|Internet.TV|NetCast|NETTV|AppleTV|boxee|Kylo|Roku|DLNADOC|CE\-HTML/i
        'tv'
      # tv-based gaming console
      elsif ua =~/Xbox|PLAYSTATION.3|Wii/i
        'tv'
      # tablet
      elsif ua =~ /iPad/i || ua =~ /tablet/i && !(ua =~ /RX-34/i) || ua =~ /FOLIO/i    
        'tablet'
      #android tablet
      elsif ua =~ /Linux/i && ua =~ /Android/i && !(ua =~ /Fennec|mobi|HTC.Magic|HTCX06HT|Nexus.One|SC-02B|fone.945/i)
        'tablet'
      #Kindle or Kindle Fire
      elsif ua =~ /Kindle/i || ua =~ /Mac.OS/i && ua =~ /Silk/i
        'tablet'
      #pre Android 3.0 Tablet
      elsif ua =~ /GT-P10|SC-01C|SHW-M180S|SGH-T849|SCH-I800|SHW-M180L|SPH-P100|SGH-I987|zt180|HTC(.Flyer|\_Flyer)|Sprint.ATP51|ViewPad7|pandigital(sprnova|nova)|Ideos.S7|Dell.Streak.7|Advent.Vega|A101IT|A70BHT|MID7015|Next2|nook/i || ua =~ /MB511/i && ua =~ /RUTEM/i
        'tablet'
      #unique Mobile User Agent
      elsif ua =~ /BOLT|Fennec|Iris|Maemo|Minimo|Mobi|mowser|NetFront|Novarra|Prism|RX-34|Skyfire|Tear|XV6875|XV6975|Google.Wireless.Transcoder/i
        'mobile'
      #odd Opera User Agent - http://goo.gl/nK90K
      elsif ua =~ /Opera/i && ua =~ /Windows.NT.5/i && ua =~ /HTC|Xda|Mini|Vario|SAMSUNG\-GT\-i8000|SAMSUNG\-SGH\-i9/i
        'mobile'
      #Windows Desktop
      elsif ua =~ /Windows.(NT|XP|ME|9)/ && !(ua =~ /Phone/i) || ua =~ /Win(9|.9|NT)/i
        'desktop'
      #Mac Desktop
      elsif ua =~ /Macintosh|PowerPC/i && !(ua =~ /Silk/i)
        'desktop'
      #Linux Desktop
      elsif ua =~ /Linux/i && ua =~ /X11/i
        'desktop'
      #Solaris, SunOS, BSD Desktop
      elsif ua =~ /Solaris|SunOS|BSD/i
        'desktop'
      #Desktop BOT/Crawler/Spider
      elsif ua =~ /Bot|Crawler|Spider|Yahoo|ia_archiver|Covario-IDS|findlinks|DataparkSearch|larbin|Mediapartners-Google|NG-Search|Snappy|Teoma|Jeeves|TinEye/i && !(ua =~ /Mobile/i)
        'desktop'
      #assume it is a Mobile Device (mobile-first)
      else
         "mobile"
      end
      o
    end
  
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end