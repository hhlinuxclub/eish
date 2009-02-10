module UsersHelper
  def link_to_profile(user)
    name = user.first_name + " " + user.last_name
    if user.username.nil?
      return h(name)
    else
      return link_to name, "/profile/#{user.username}"
    end
  end
end
