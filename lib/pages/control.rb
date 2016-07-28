# filename: lib/pages/control.rb

require_relative 'actions'

module Pages
  module Control
    class << self

      include Pages::Actions

      def specify(control_id)
        @found_cell = wait { id control_id }
        self
      end

    end
  end # module Control
end # module Pages

module Kernel
  def control
    Pages::Control
  end
end
