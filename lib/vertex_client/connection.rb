module VertexClient
  class Connection

    VERTEX_NAMESPACE = 'urn:vertexinc:o-series:tps:7:0'.freeze
    ERROR_MESSAGE = 'The Vertex API returned an error or is unavailable'.freeze

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def request(payload)
      call_with_circuit_if_available do
        client.call(
          :vertex_envelope,
          message: shell_with_auth.merge(payload)
        )
      end
    end

    def client
      @client ||= Savon.client do |globals|
        globals.endpoint clean_endpoint
        globals.namespace VERTEX_NAMESPACE
        globals.convert_request_keys_to :camelcase
        globals.env_namespace :soapenv
        globals.namespace_identifier :urn
        globals.open_timeout open_timeout if open_timeout
        globals.read_timeout read_timeout if read_timeout
      end
    end

    def config
      @config ||= VertexClient.configuration
    end

    private

    def call_with_circuit_if_available
      if VertexClient.circuit
        VertexClient.circuit.run { yield }
      else
        begin
          yield
        rescue => _e
          nil
        end
      end
    end

    def shell_with_auth
      {
        login: { trusted_id: @config.trusted_id }
      }
    end

    def clean_endpoint
      URI.join(config.soap_api, @endpoint).to_s
    end

    def read_timeout
      config.read_timeout
    end

    def open_timeout
      config.open_timeout
    end
  end
end
