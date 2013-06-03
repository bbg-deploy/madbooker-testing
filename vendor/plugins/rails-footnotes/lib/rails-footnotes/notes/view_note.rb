require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class ViewNote < AbstractNote
      def initialize(controller)
        @controller = controller
        @template = controller.view_context
        # Rails.logger.debug controller.view_context_class.inspect.yellow
        # Rails.logger.debug @template.class.name.inspect.yellow
        # #Rails.logger.debug @template.to_path.red
        # Rails.logger.debug @template.private_methods.sort.inspect.yellow
        # Rails.logger.debug @template.instance_variables.sort.inspect.red
        # Rails.logger.debug @template.instance_variable_get(:@_virtual_path).inspect.yellow
        # Rails.logger.debug @template.instance_variable_get(:@view_context_class).inspect.yellow
        # Rails.logger.debug @template.instance_variable_get(:@lookup_context).inspect.yellow
        # Rails.logger.debug @template.instance_variable_get(:@lookup_context).registered_details.methods.sort.inspect.yellow
        # Rails.logger.debug @template.instance_variable_get(:@lookup_context).instance_variables.sort.inspect.blue
        # Rails.logger.debug @template.instance_variable_get(:@lookup_context).instance_variable_get(:@details_key).instance_variable_get(:@hash).inspect.yellow
        # Rails.logger.debug @template.instance_variable_get(:@_view_runtime).inspect.red
      end

      def row
        :edit
      end
      

      def link
        escape(Footnotes::Filter.prefix(filename, 1, 1))
      end

      def valid?
        false #prefix? && first_render?
      end

      protected

        def first_render?
          @template.instance_variable_get(:@_first_render)
        end

        def filename
          ''#@filename ||= @template.instance_variable_get(:@_first_render).filename
        end

    end
  end
end
