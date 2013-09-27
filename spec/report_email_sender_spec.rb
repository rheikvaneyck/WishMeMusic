require 'yaml'
require 'pony'

class ReportMailer
end

describe ReportMailer do
  it "report_email_sener sends the html email file" do
    config_file = File.join(File.dirname(__FILE__), '..','config','email.yml')
    if File.exists?(config_file) then
      mailer_config = YAML.load_file(config_file)
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
    else
      puts '---'
      puts "This test needs real credentials and server options for a smtp server."
      puts "Contents of #{config_file} should be something similar to this:"
      puts '---'
      puts 'to: "you@exampl.com"'
      puts 'via:  "smtp"'
      puts 'address:  "mail.server.com"'
      puts 'port: "587"'
      puts 'enable_starttls_auto: "true"'
      puts 'user_name: "user"'
      puts 'password: "password"'
      puts 'authentication: "plain"'
      puts 'domain: "localhost.localdomain"'
      puts '---'
      true
    end
  end
end