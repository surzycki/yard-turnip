require 'yard'

module YARD
  module CodeObjects
    class StepsForObject < ModuleObject
      def type
        :module
      end
    end

    class StepObject < MethodObject
      def type
        :method
      end
    end
  end

  class StepsForHandler < Handlers::Ruby::Base
    handles method_call(:steps_for)

    def process
      name = statement.parameters.first.jump(:tstring_content, :ident).source
      mod = register(CodeObjects::StepsForObject.new(namespace, name))
      parse_block(statement[2][1], :namespace => mod)
    end
  end

  class StepHandler < Handlers::Ruby::Base
    handles method_call(:step)

    def process
      name = statement.parameters.first.jump(:tstring_content, :ident).source
      object = CodeObjects::StepObject.new(namespace, name)
      register(object)
    end
  end

  module Templates::Helpers
    module HtmlHelper
      def anchor_for(object)
        case object
        when CodeObjects::MethodObject
          "#{object.name.to_s.gsub(/ /, '+')}-#{object.scope}_#{object.type}"
        when CodeObjects::ClassVariableObject
          "#{object.name.to_s.gsub(/ /, '+').to_s.gsub('@@', '')}-#{object.type}"
        when CodeObjects::Base
          "#{object.name.to_s.gsub(/ /, '+')}-#{object.type}"
        when CodeObjects::Proxy
          object.path
        else
          object.to_s
        end
      end
    end
  end
end
