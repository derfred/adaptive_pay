module AdaptivePay
  class Request

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

  end
end
