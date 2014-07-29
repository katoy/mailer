# -*- coding: utf-8 -*-

require 'rest_client'
require 'json'
require 'awesome_print'
require 'open3'
require 'kconv'

class MailcatcherDriver
  # Initializer.
  # @param  url URL of the MailCatcher (default: 'http://localhost:1080')
  def initialize(url = 'http://localhost:1080')
    @url = url
  end

  # Start MailCatcher.
  # @param opt  opiton of command-line.
  # @return [stdout, stderr, status]
  def start(opts = '')
    out, err, status = Open3.capture3("mailcatcher #{opts}")
    [out, err, status]
  end

  # Quit the MailCatcher.
  # @return reponse.status
  def quit
    response = RestClient.delete @url
    response.code
  end

  # Clear all messages.
  # @return reponse.status
  def clear
    response = RestClient.delete "#{@url}/messages"
    response.code
  end

  # Delete messages
  # @param  Array of message_id.
  # @return Array of response.status
  def delete_messages(ids)
    ans = []
    return ans if ids.nil?
    ids.each do |id|
      begin
        response = RestClient.delete "#{@url}/messages/#{id}"
        ans << response.code
      rescue => ex
        ans << ex.to_s
      end
    end
    ans
  end

  # get で url にアクセスした時の response を返す。
  # @param url
  # @see http://mailcatcher.me/
  def response_get(url)
    RestClient.get url
  end

  # Get all message_id.
  # @return Array of message_id
  def ids
    ids = []
    all_messages.each { |m| ids << m['id'] }
    ids
  end

  # Get all messages.
  # @return Array of all messages
  def all_messages
    response = RestClient.get "#{@url}/messages"
    JSON.parse response.body
  end

  # Get some messages.
  # @param fmt  :plain, :json, :source
  # @param ids  Array of message_id
  # @return Array of message json
  def message(fmt, ids)
    ans = []
    return ans if ids.nil?
    ids.each do |id|
      response = RestClient.get "#{@url}/messages/#{id}.#{fmt}"
      if fmt == :plain
        ans << response.body.toutf8
      elsif fmt == :json
        ans << JSON.parse(response.body)
      else
        ans << response.body
      end
    end
    ans
  end

   # 添付ファイル情報　(:cid, :type, filename, size, href) の配列を得る
  def attacheds(id)
    json = JSON.parse(RestClient.get "#{@url}/messages/#{id}.json")
    ans = []
    ans = json['attachments'] if json['attachments']
    ans
  end

  # 添付ファイルを得る
  def attached(id, cid)
    response = RestClient.get "#{@url}/messages/#{id}/parts/#{cid}"
    response
  end
end

# --- End of File ---
