require 'vertex_client/version'
require 'savon'

module VertexClient

  autoload :Configuration, 'vertex_client/configuration'
  autoload :Connection,    'vertex_client/connection'
  autoload :Payload,       'vertex_client/payload'
  autoload :Response,      'vertex_client/response'

  class << self
    attr_accessor :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def reconfigure!
      @configuration = Configuration.new
      yield(@configuration) if block_given?
    end

    def configure
      yield(configuration)
    end

    def quotation(payload)
      Connection.new.quotation(payload)
    end
  end

  class Error < StandardError; end

end
