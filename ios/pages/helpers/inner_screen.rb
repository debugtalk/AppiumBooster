# filename: ios/pages/helpers/inner_screen.rb

module Pages
  module InnerScreen
    class << self

      def has_text(text)
        wait { text_exact text }
      end

      def has_button(name)
        wait { button_exact name }
      end

      def has_class(name)
        wait { tag name }
      end

      def has_control(control_id)
        wait { id control_id }
      end

    end
  end
end

module Kernel
  def inner_screen
    Pages::InnerScreen
  end
end
