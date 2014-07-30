# -*- coding: utf-8 -*-

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper.rb')

describe 'MailcatcherDriver start/stop' do

  before(:all) do
    @mc = MailcatcherDriver.new
    @mc.start
    @mc.clear

    @mail_infos = {
      from: 'foo_from@example.com',
      to:  'foo_to@example.com',
      subject: 'テストメール Subject',
      body: "テストメール本文1\n本文2",
    }.freeze

    @mail_infos2 = {
      from: 'foo_from2@example.com',
      to:  'foo_to2@example.com',
      subject: 'テストメール Subject2',
      body: "テストメール本文10\n本文20",
      files: [
              { name: 'test-002.txt', content:  '添付ファイルの内容2' },
              { name: 'fish.png',
                content: File.read(File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'sample', 'fish.png'))}
             ],
    }.freeze
  end

  after(:all) do
    @mc.quit
  end

  it 'should be empty after start' do
    @mc.quit
    @mc.start
    expect(@mc.ids).to eq([])
  end

  it 'after send mail' do
    count = @mc.ids.size

    MyMailer.send_mail @mail_infos
    ids = @mc.ids
    expect(ids.size).to eq(count + 1)
    expect(@mc.message :plain, [ids[-1]]).to eq(["テストメール本文1\n本文2"])

    json = @mc.message :json,  [ids[-1]]
    expect(json[0]['id']).to eq(1)
    expect(json[0]['sender']).to eq('<foo_from@example.com>')
    expect(json[0]['recipients']).to eq(['<foo_to@example.com>'])
    expect(json[0]['subject']).to eq('テストメール Subject')
    expect(json[0]['type']).to eq('text/plain')
    expect(json[0]['formats']).to eq(%w(source plain))
  end

  it 'after send mail (multipart)' do
    @mc.clear

    MyMailer.send_mail @mail_infos2
    ids = @mc.ids
    expect(ids.size).to eq(1)
    expect(@mc.message :plain, [ids[-1]]).to eq(["テストメール本文10\n本文20"])

    json = @mc.message :json,  [ids[-1]]
    expect(json[0]['id']).to eq(1)
    expect(json[0]['sender']).to eq('<foo_from2@example.com>')
    expect(json[0]['recipients']).to eq(['<foo_to2@example.com>'])
    expect(json[0]['subject']).to eq('テストメール Subject2')
    expect(json[0]['type']).to eq('multipart/mixed')
    expect(json[0]['formats']).to eq(%w(source plain))

    attacheds = @mc.attacheds 1
    expect(attacheds.size).to eq(2)
    expect(attacheds[0]['type']).to eq('image/png')
    expect(attacheds[0]['filename']).to eq('fish.png')
    expect(attacheds[0]['size']).to eq(37477)

    expect(attacheds[1]['type']).to eq('text/plain')
    expect(attacheds[1]['filename']).to eq('test-002.txt')
    expect(attacheds[1]['size']).to eq(28)
  end

  it 'clear all messages' do
    @mc.clear
    expect(@mc.ids).to eq([])

    4.times do
      MyMailer.send_mail @mail_infos
      MyMailer.send_mail @mail_infos2
    end
    sleep 1
    expect(@mc.ids.sort).to eq([1,2,3,4,5,6,7,8])

    res = @mc.clear
    expect(res).to eq(204)
    expect(@mc.ids).to eq([])
  end

  it 'delete mail' do
    pending 'delete_message return 500, Why?'

    MyMailer.send_mail @mail_infos
    MyMailer.send_mail @mail_infos
    MyMailer.send_mail @mail_infos
    MyMailer.send_mail @mail_infos
    sleep 2

    ids = @mc.ids.freeze
    expect(@mc.ids).to eq([1, 2, 3, 4])

    # 2 番目のメールを削除する
    sleep 0.5
    res = @mc.delete_messages [2]
    expect(res).to eq([200])
    expect(@mc.ids).to eq([1, 3, 4])

    # 1 番目のメールを削除する
    sleep 0.5
    res = @mc.delete_messages [1]
    expect(res).to eq([200])
    expect(@mc.ids).to eq([3, 4])

  end

  # it "after send mail with attachment" do
  #  pending "not yet"
  # end

end
