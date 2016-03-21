# SNS Mock
This was created so we could have a SNS-like pub/sub experience in our local environment.

## Usage
To start it up

    ruby index.rb

If you're using the AWS Ruby SDK, you can pass the `endpoint` option pointing to this sinatra app.

    Aws::SNS::Client.new(
      region: "us-west-1",
      endpoint: http://localhost:4567 
    )


From there, your `subscribe` and `publish` methods should "just work".
