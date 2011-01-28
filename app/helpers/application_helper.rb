module ApplicationHelper
  
  def javascript_include_flash
    if flash.detect {|name, msg| !msg.blank?}        
      return javascript_include_tag 'flash'
    end
  end
  
  def facebook_oauth_url
     MiniFB.oauth_url(APP_CONFIG[:facebook]['api_key'],facebook_oauth_callback_url, 
                                  :scope=>"publish_stream,email,offline_access,user_about_me,
                                  user_birthday,user_interests,user_activities,
                                  user_relationships,user_status,user_photos,user_relationship_details,friends_about_me,
                                  friends_birthday,friends_interests,friends_activities,
                                  friends_relationships,friends_status,friends_photos,friends_relationship_details")
  end
  
  def show_row(label, attribute)
    label += ": " unless label.blank?
    "<li><label>#{label}</label><span class='value'>#{attribute}</span></li>"
  end

  def fieldset_for(collection, *args)
    legend = args.shift
    out = ["<fieldset class='showtastic'>","<legend>#{legend}</legend><ol>",rows_for(collection, *args),"</ol></fieldset>"].join("\n").html_safe
  end

  def rows_for(collection, *args)
    out = args.map do |arg|
      if arg.is_a? Array
        if arg[1].is_a? Symbol
          show_row(arg[0], collection.send(arg[1]))
        else
          show_row(arg[0], arg[1])
        end
      else
        show_row(arg.to_s.humanize, collection.send(arg))
      end
    end
    out.join("\n").html_safe
  end
  
end
