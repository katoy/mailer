
[![Build Status](https://travis-ci.org/katoy/mailer.png?branch=master)](https://travis-ci.org/katoy/mailer)
[![Dependency Status](https://gemnasium.com/katoy/mailer.png)](https://gemnasium.com/katoy/mailer)
[![Coverage Status](https://coveralls.io/repos/katoy/mailer/badge.png?branch=master)](https://coveralls.io/r/katoy/mailer?branch=master)

# メール送信を  cucumber + mailcatchre でテストする

    $ bundle install
    $ bundle exec ruby sample/sample-00.rb
    $ bundle exec rspec

text, png, pdf を添付ファイルとしたメールを activemailer で送信し、 mailcather からメールデータを取得して、
その内容をチェックするテストを rspec で実行できるようにしてある。

# 備考

次の方法で、mailcatcher に swks でメールを送ることが可能。
(swaks  は MacOS なら 'brew install swaks' でインストールできる)

    $ swaks -f youichikato@example.com -t youichikato@example.com -s localhost -p 1025
    $ swaks -f youichikato@example.com -t youichikato@example.com -s localhost -p 1025 --attach sample/fish.png

次の方法で、 mailcatcher に get, delete などのリクエストを送ることができる。

    $ restclient
	> RestClient.get "http://localhost:1080/messages"
    > RestClient.delete "http://localhost:1080/messages"

# TODO:

- jenkins との連携
- mailcatcher のスクリーンショットを撮る事。

//--- End of File ---
