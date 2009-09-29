require "net/http"
require "net/https"

module AdaptivePay
  class Request

    cattr_accessor :endpoint

    class_inheritable_accessor :attributes
    self.attributes = []

    def self.attribute(name, options={})
      top_level_name = name.to_s.split(".").last.underscore
      define_method top_level_name do
        read_attribute name
      end

      define_method "#{top_level_name}=" do |value|
        write_attribute name, value
      end

      self.attributes << options.merge(:name => name)
    end

    def self.attribute_names
      self.attributes.map { |a| a[:name] }
    end


    def initialize(&block)
      @attributes = {}
      self.class.attributes.each do |k|
        write_attribute k[:name], k[:default]
      end
      yield self if block_given?
    end

    def read_attribute(name)
      @attributes[name]
    end

    def write_attribute(name, value)
      @attributes[name] = value
    end


    def perform(interface)
      uri = construct_uri(interface)
      request = Net::HTTP::Post.new uri.request_uri
      request.initialize_http_header(headers(interface))
      http_response = build_http(uri).request request
      Response.new http_response
    end

    protected
      def construct_uri(interface)
        URI.parse("#{interface.base_url}/#{self.class.endpoint}".gsub("!://", "/"))
      end

      def build_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.port == 443)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def headers(interface)
        {
          "X-PAYPAL-SECURITY-USERID" => interface.username,
          "X-PAYPAL-SECURITY-PASSWORD" => interface.password,
          "X-PAYPAL-SECURITY-SIGNATURE" => interface.signature,
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "NV",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON"
        }
      end

  end
end
