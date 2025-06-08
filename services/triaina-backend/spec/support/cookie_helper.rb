module CookieHelper
  # Pass (request , response.cookies.to_h)
  def build_cookie_jar(request, cookies_hash)
    ActionDispatch::Cookies::CookieJar.build(request, cookies_hash)
  end
end
