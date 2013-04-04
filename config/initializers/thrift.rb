if Rails.env == 'test'
  $LOAD_PATH << 'lib/mock_backend'
  require 'recommender'
  THRIFTCLIENT = Backend::Recommender::Client.new('fake protocol')
else
  $LOAD_PATH << 'lib/thrift/gen-rb'
  require 'thrift'
  require 'recommender'

  begin
    transport = Thrift::FramedTransport.new(Thrift::Socket.new('127.0.0.1', 9090))
    protocol = Thrift::BinaryProtocol.new(transport)
    THRIFTCLIENT = Backend::Recommender::Client.new(protocol)

    transport.open
    if THRIFTCLIENT.ping != "Pong"
      raise Thrift::TransportException
    end
  rescue Thrift::TransportException => e
    STDERR.write "Cannot Connect to Thrift Backend. Exiting...\n"
    Process.exit
  end
end
