module DataMapper
  module MetaMapper
    class NoGeneratorError < ArgumentError; end
    class InvalidTypeError < StandardError; end

    class TemplateCollection < Array
      def models
        self.select {|t| t.type == :model}
      end

      def global
        self.select {|t| t.type == :global}
      end
    end

    class Template
      VALID_TYPES = [:global, :model]

      def initialize(name, opts={})
        @name          = name.to_s
        @generator     = parse_generator(opts.delete(:generator))
        @type          = parse_type(opts.delete(:type))
        @template_name = parse_template(opts.delete(:template))
      end

      attr_reader :name, :type

      def output_path
        File.join(@generator.config.output_dir, @name)
      end

      def full_path
        File.join(@generator.config.template_dir, @template_name)
      end

      private

      def parse_type(type)
        return type if type && VALID_TYPES.include?(type.to_sym)

        raise InvalidTypeError, "type `#{type}' is not a recognized template " + 
                                "type. Valid types: #{VALID_TYPES.inspect}]" 
      end

      def parse_generator(generator)
        generator || raise(NoGeneratorError, "opts did not contain :generator")
      end

      def parse_template(template)
        (template || @name).to_s + ".erb"
      end
    end
  end
end

