$LOAD_PATH << 'lib/thrift/gen-rb'

require 'thrift'
require 'thrift/gen-rb/recommender'

begin
  # Note: for now, these variables are inaccessible by the rest of the
  # application. TODO: rectify this when we start adding more api calls to
  # thrift
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

