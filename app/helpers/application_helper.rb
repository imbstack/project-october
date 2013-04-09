module ApplicationHelper
  def gravatar_url(user, size=128)
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "//gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=mm"
  end
end
