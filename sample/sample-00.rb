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
#puts '--------------------------- clear'
#ap mc.clear

# 添付ファイル付きのメールを送る
mail_infos[:subject] =  'テストメール Subject (添付ファイル有り)'
mail_infos[:body] = 'テストメール本文 (添付ファイル有り)'
mail_infos[:files] =[
                     { name: 'test-001.txt', content:  '添付ファイルの内容' },
                     { name: 'fish.png',
                       content: File.read(File.join(File.expand_path(File.dirname(__FILE__)), '..', 'sample', 'fish.png'))}
                    ]
MyMailer.send_mail mail_infos

puts '--------------------------- 添付ファイル付きのメール'
puts '--------------------------- ids'
ap mc.ids

# 本文を得る
puts '--------------------------- messages plain'
ap mc.message :plain, [1]

# 添付ファイルを得る
puts '--------------------------- attacheds'
attacheds = mc.attacheds 2
ap attacheds

attacheds.each do |at|
  puts "--------添付ファイル: #{at['filename']} ------"
  ap at
  cont = mc.attached 2, at['cid']
  if at['type'] == 'text/plain'
    ap cont.toutf8
  else
    ap "#{cont}"[0..10] + " ..."
    ap "#{cont.unpack('C*')[0..60]}" + " ... (snip) size: #{at['size']}"
  end
end

puts '--------------------------- quit'
ap mc.quit
