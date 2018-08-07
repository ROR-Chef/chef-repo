node.override['acme']['contact'] = ['mailto:wiki11official@gmail.com']

# Email address that will be notified of events.
node.override['monit']['alert_email'] = 'root@localhost'

node.override['monit']['mail'] = {
  hostname: ENV['MAILER_HOST'],
  port:     587,
  username: ENV['MAILER_USER_NAME'],
  password: ENV['MAILER_PASSWORD'],
  encrypted_credentials: nil,
  encrypted_credentials_data_bag: "credentials",
  from:     "monit@$HOST",
  subject:  "$SERVICE $EVENT at $DATE",
  message:  "Monit $ACTION $SERVICE at $DATE on $HOST,\n\n$DESCRIPTION\n\nDutifully,\nMonit",
  security: nil,  # 'SSLV2'|'SSLV3'|'TLSV1'
  timeout:  30,
  using_hostname: nil
}
