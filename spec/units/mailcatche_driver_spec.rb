# -*- coding: utf-8 -*-

require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'spec_helper.rb')

describe 'MailcatcherDriver start/stop' do

  before(:all) do
    @mc = MailcatcherDriver.new
    @mc.start
    @mail_infos = {
      from: 'foo_from@example.com',
      to:  'foo_to@example.com',
      subject: 'テストメール Subject',
      body: "テストメール本文1\n本文2",
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

  it 'clear all messages' do
    MyMailer.send_mail @mail_infos
    res = @mc.clear
    expect(res).to eq(204)
    ids = @mc.ids
    expect(ids.size).to eq(0)
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
