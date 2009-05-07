module UsersHelper
  def link_to_profile(user)
    name = user.first_name + " " + user.last_name
    if user.username.nil?
      return h(name)
    else
      return link_to(name, profile_path(user))
    end
  end
  
  def gravatar(email)
    require 'digest/md5'
    return "http://www.gravatar.com/avatar/" + Digest::MD5.hexdigest(email) + "?r=pg&d=" + request.protocol + request.host_with_port + "/images/avatar.png"
  end
end
