require 'thrift'

$:.push('lib/thrift/gen-rb')
require 'recommender'

class HomeController < ApplicationController
  def index
    transport = Thrift::FramedTransport.new(Thrift::Socket.new('127.0.0.1', 9090))
    protocol = Thrift::BinaryProtocol.new(transport)
    client = Recommender::Client.new(protocol)

    transport.open()

    @answer = client.ping()
  end
end
