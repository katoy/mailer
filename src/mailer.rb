# coding: utf-8

require 'action_mailer'

class MyMailer < ActionMailer::Base
  # mailcatcher  を利用する設定
  ActionMailer::Base.smtp_settings = {
    # ----- for mailcatcher
    address: 'localhost',
    port: 1025,
    domain: 'example.com',
    authentication: :plain,
    # ----- for using gmail
    # enable_starttls_auto: true,
    # address: 'smtp.gmail.com',
    # port:  '587',
    # domain: 'smtp.gmail.com',
    # authentication: 'plain',
    # user_name: 'your_name@gmail.com',
    # password: 'your_password',
  }
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.delivery_method = :smtp

  # メールを送信する。
  def self.send_mail(infos)
    def create(infos)
      mail(
           from: infos[:from],
           to: infos[:to],
           subject: infos[:subject],
           body: infos[:body],
           cc: infos[:cc],
           bcc: infos[:bcc],
           )
    end

    message = create(infos)
    message.deliver  # deliver メソッドで実際に送信をすることができる。
  end
end

if __FILE__ == $PROGRAM_NAME
  # メールの送信
  infos = {
    from: 'youichikato@gmail.com',
    to:  'youichikato@gmail.com',
    subject: 'テストメール Subject',
    body: 'テストメール本文',
    cc: [],
    bcc: ['youichikato@gmail.com'],
  }
  MyMailer.send_mail infos

end
#--- End of File
