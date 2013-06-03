require "#{File.dirname(__FILE__)}/abstract_note"

module Footnotes
  module Notes
    class LayoutNote < AbstractNote
      def initialize(controller)
        @controller = controller
      end

      def row
        :edit
      end

      def link
        escape(Footnotes::Filter.prefix(filename, 1, 1))
      end

      def valid?
        prefix? && @controller.action_has_layout?
      end

      protected
        def filename
          File.join(File.expand_path(Rails.root), 'app', 'layouts', "#{@controller.instance_variable_get(:@_layout).to_s.underscore}", @controller.send( :_default_layout).to_s.underscore).sub('/layouts/layouts/', '/views/layouts/')
        end
    end
  end
end
