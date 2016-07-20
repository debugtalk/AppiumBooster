# filename: lib/pages/inner_screen.rb

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

      def has_control(control_ids)
        '''check if control element exists.
          - if control_ids is like A||B, either A or B exists will be OK.
          - if control_ids is like A&&B, only A and B exists will be OK.
        '''
        if control_ids.include? '&&'
          control_ids.split('&&').each do |control_element|
            wait { id control_element }
          end
        else
          element_exist = false
          control_ids.split('||').each do |control_element|
            begin
              wait { id control_element }
              element_exist = true
              break
            rescue Selenium::WebDriver::Error::TimeOutError => ex
            end
          end
          raise "#{control_ids} not exsit" if not element_exist
        end
      end

      def has_no_control(control_id)
        begin
          wait { id control_id }
          raise "#{control_id} still exsits!"
        rescue Selenium::WebDriver::Error::TimeOutError => ex
        end
      end

    end
  end
end

module Kernel
  def inner_screen
    Pages::InnerScreen
  end
end
