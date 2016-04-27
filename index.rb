require 'sinatra'
require 'json'
require 'rest-client'

set :bind, '0.0.0.0'

$subscriptions = {}
get '/*' do
  $subscriptions.each do |k, v|
    puts "**"
    puts k
    v.each {|val| puts val}
    puts "**"
  end
  $subscriptions.to_json
end

post '/*' do
  data = params
  case data["Action"].downcase
  when "subscribe"
    puts "** SUBSCRIBING"
    $subscriptions[data["TopicArn"]] ||= Set.new
    $subscriptions[data["TopicArn"]] << data["Endpoint"]

    return "<SubscribeResponse xmlns='http://sns.amazonaws.com/doc/2010-03-31/'><SubscribeResult><SubscriptionArn>#{data['TopicArn']}</SubscriptionArn></SubscribeResult><ResponseMetadata><RequestId>c4407779-24a4-56fa-982c-3d927f93a775</RequestId></ResponseMetadata></SubscribeResponse>"

  when "publish"
    puts "PUBLISH"

    msg = JSON.parse(data["Message"])["default"]
    puts "publishing #{msg}"
    subscribers = $subscriptions[data["TopicArn"]] || []
    subscribers.each do |url|
      publish(url, msg, data["TopicArn"])
    end
    return "<PublishResponse xmlns='http://sns.amazonaws.com/doc/2010-03-31/'> <PublishResult> <MessageId>94f20ce6-13c5-43a0-9a9e-ca52d816e90b</MessageId> </PublishResult> <ResponseMetadata> <RequestId>f187a3c1-376f-11df-8963-01868b7c937a</RequestId> </ResponseMetadata> </PublishResponse>"
  end
end

def publish(url, msg, topic)
  puts "publishing on #{url}"
  RestClient.post(url, "{\"Message\": #{msg.to_json}}", content_type: :json, accept: :json, "x-amz-sns-topic-arn" => topic )
rescue => ex
  puts "*** PUBLISH ERROR"
  puts ex.inspect
  puts "*** *****"
end
