require "net/http"
require "net/https"
require 'bigdecimal/util'

module AdaptivePay
  class Request

    def self.response_type
      :other
    end

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
        write_attribute k[:name], k[:default] if k[:default]
      end
      yield self if block_given?
    end

    def read_attribute(name)
      @attributes[name]
    end

    def format_attribute(name)
      attrib = self.class.attributes.find { |a| a[:name] == name }
      case
      when attrib.nil?
        nil
      when attrib[:format] == :date
        @attributes[name].strftime("%Y-%m-%d")
      else
        @attributes[name]
      end
    end

    def write_attribute(name, value)
      @attributes[name] = value
    end


    def perform(interface)
      uri = construct_uri(interface)
      request = Net::HTTP::Post.new uri.request_uri
      request.body = serialize
      request.initialize_http_header(headers(interface))
      http_response = build_http(uri).request request
      Response.new interface, self.class.response_type, http_response
    end

    def serialize
      result = []
      all_attributes.each do |k, v|
        result << "#{k}=#{URI.escape(v.to_s)}"
      end
      result.join("&")
    end

    protected
      def construct_uri(interface)
        if interface.base_url.ends_with?("/")
          URI.parse("#{interface.base_url}#{self.class.endpoint}")
        else
          URI.parse("#{interface.base_url}/#{self.class.endpoint}")
        end
      end

      def build_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.port == 443)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http
      end

      def headers(interface)
        {
          "X-PAYPAL-SECURITY-USERID" => interface.username.to_s,
          "X-PAYPAL-SECURITY-PASSWORD" => interface.password.to_s,
          "X-PAYPAL-SECURITY-SIGNATURE" => interface.signature.to_s,
          "X-PAYPAL-APPLICATION-ID" => interface.application_id.to_s,
          "X-PAYPAL-REQUEST-DATA-FORMAT" => "NV",
          "X-PAYPAL-RESPONSE-DATA-FORMAT" => "NV"
        }
      end

      def all_attributes
        result = {}
        self.class.attribute_names.each do |name|
          value = read_attribute(name)
          result[name] = format_attribute(name) unless value.nil?
        end
        result.merge(extra_attributes)
      end

      def extra_attributes
        {}
      end

  end
end
