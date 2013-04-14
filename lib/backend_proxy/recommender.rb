$LOAD_PATH.unshift 'lib/thrift/gen-rb'

require 'mock_backend/recommender'
require 'thrift'
require 'thrift/gen-rb/recommender'

module Backend
  module RecommenderProxy
    class Client
      def initialize
        if Rails.env.test?
          STDERR.write "API: Testing detected, using Mock backend\n"
          @client = Backend::RecommenderMock::Client.new('fake')
          return
        end

        begin
          @client = try_connect()
        rescue Thrift::TransportException => e
          Rails.logger.error "API: Cannot Connect to Thrift Backend. Using the mock backend instead..."
          @client = Backend::RecommenderMock::Client.new('fake')
          @read_only_mode = true
        end
      end

      def try_connect
        transport = Thrift::FramedTransport.new(Thrift::Socket.new('127.0.0.1', 9090))
        protocol = Thrift::BinaryProtocol.new(transport)
        client = Backend::Recommender::Client.new(protocol)

        transport.open

        if client.ping == "Pong"
          @read_only_mode = false
          return client
        else
          raise Thrift::TransportException, 'API: Backend is up to something weird.'
        end
      end

      def method_missing(m, *args)
        if @read_only_mode
          begin
            @client = try_connect()
            time = Benchmark.measure { @result = @client.send(m, *args) }
            return @result
          rescue
            Rails.logger.error "API: Tried to reconnect to Thrift, but couldn't."
            time = Benchmark.measure { @result = @client.send(m, *args) }
          end
        end

        begin
          time = Benchmark.measure { @result = @client.send(m, *args) }
        rescue
          Rails.logger.error "API: Transport exception received! Attempting reconnect..."
          begin
            @client = try_connect()
            time = Benchmark.measure { @result = @client.send(m, *args) }
          rescue
            Rails.logger.error 'API: Second transport exception received! Falling back to MockBackend.'
            @client = Backend::RecommenderMock::Client.new('uh oh')
            @read_only_mode = true
            time = Benchmark.measure { @result = @client.send(m, *args) }
          end
        end

        Rails.logger.debug "API: Called #{@read_only_mode ? 'fake ' : '' }method #{m} in #{time.real.round(2)}s"

        @result
      end

      def read_only_mode?
        @read_only_mode
      end
    end
  end
end
