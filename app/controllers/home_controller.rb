require 'thrift'

$:.push('lib/thrift/gen-rb')
require 'recommender'

class HomeController < ApplicationController
  def index
    transport = Thrift::BufferedTransport.new(Thrift::Socket.new('localhost', 9090))
    protocol = Thrift::BinaryProtocol.new(transport)
    client = Recommender::Client.new(protocol)

    transport.open()

    @answer = client.ping()
  end
end
