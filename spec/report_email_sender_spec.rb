require 'yaml'
require 'pony'

class ReportMailer
end

describe ReportMailer do
  it "report_email_sener sends the html email file" do
    mailer_config = YAML.load_file(File.join('..','config','email.yml'))
    body_html = File.read('email.html')
    body_text = "WishMeMusic Email Test"

    Pony.options = {
      :via =>  mailer_config["via"],
      :address => mailer_config["address"],
      :port => mailer_config["port"],
      :enable_starttls_auto => mailer_config["enable_starttls_auto"],
      :user_name => mailer_config["user_name"],
      :password => mailer_config["password"],
      :authentication => mailer_config["authentication"],
      :domain => mailer_config["domain"]
    }

    Pony.mail(:to => mailer_config["to"], 
      :cc => mailer_config["cc"], 
      :from => mailer_config["from"],
      :subject => "WishMeMusic Event Report",
      :content_type => "text/html",
      :body => body_html)

  end
end