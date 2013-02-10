require 'thrift'

$:.push('lib/thrift/gen-rb')
require 'recommender'

class HomeController < ApplicationController
  def index
    transport = Thrift::FramedTransport.new(Thrift::Socket.new(
        Rails.application.config.recommender_host,
        Rails.application.config.recommender_port))
    protocol = Thrift::BinaryProtocol.new(transport)
    client = Recommender::Client.new(protocol)

    transport.open()

    @answer = client.ping()
  end
end
