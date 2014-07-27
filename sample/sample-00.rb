# -*- coding: utf-8 -*-

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'src', 'mailer.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'src', 'mailcatcher-driver.rb')

mail_infos = {
  from: 'youichikato@gmail.com',
  to:  'youichikato@gmail.com',
  subject: 'テストメール Subject',
  body: 'テストメール本文',
}

# メールキャッチャーを開始する。既に開始済みなら何もしない。
mc = MailcatcherDriver.new
mc.start

# 現時点の全メッセージを得る
puts '--------------------------- messages_json before send'
ap mc.all_messages

# メールを送信する
MyMailer.send_mail mail_infos
# 現時点の全メッセージを得る
puts '--------------------------- messages_json after send'
ap mc.all_messages

# メール ID を全て得る。
puts '--------------------------- ids'
ids = mc.ids
ap ids

# 最後に送信されたメールの本文を得る。
puts '--------------------------- messages_plain'
ap mc.message :plain, [ids[-1]]

# json 形式で得る。
puts '--------------------------- messages_json'
ap mc.message :json, [ids[-1]]

puts '--------------------------- response get'
ap mc.response_get 'http://localhost:1080//messages'

# メールを全て削除する
puts '--------------------------- clear'
ap mc.clear

puts '--------------------------- ids'
ap mc.ids

puts '--------------------------- quit'
ap mc.quit
