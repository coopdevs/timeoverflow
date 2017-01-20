module MailHelper
  def js_antispam_email_link(email,linktext)
    # http://apidock.com/rails/ActionView/Helpers/UrlHelper/mail_to
    user, domain = email.split('@')
    # if linktext wasn't specified, throw email address builder into js document.write statement
    linktext = "'+'#{user}'+'@'+'#{domain}'+'" if linktext == email
    out = "<script language='javascript'>\n"
    out += "  <!--\n"
    out += "    string = '#{user}'+'@'+''+'#{domain}';\n"
    out += "    document.write('<a href='+'m'+'a'+'il'+'to:'+ string +'>#{linktext}</a>'); \n"
    out += "  //-->\n"
    out += "</script>\n"
    return out
  end
end