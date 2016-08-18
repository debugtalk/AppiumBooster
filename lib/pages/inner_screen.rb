# filename: lib/pages/inner_screen.rb

module Pages
  module InnerScreen
    class << self

      def should_have_text(text)
        wait { text_exact text }
      end

      def should_have_button(name)
        wait { button_exact name }
      end

      def should_have_class(name)
        wait { tag name }
      end

      def should_not_exist(control_id)
        wait { id control_id }
        raise "#{control_id} still exists!"
      rescue Selenium::WebDriver::Error::TimeOutError => ex
      end

      def check_element(control_element)
        if control_element.start_with?('!')
          control_element = control_element[1..-1]
          should_not_exist control_element
        else
          wait { id control_element }
        end
      end

      def check_elements(control_ids)
        """check if control elements exist as expectation.
          - if control_ids is like !A, A should not be existed.
          - if control_ids is like A||B, either A or B exists will be OK.
          - if control_ids is like A&&B, only A and B exists will be OK.
          - if control_ids is like A&&!B, A should be existed and B should not be existed.
        """
        check_result = true
        if control_ids.include? '&&'
          control_ids.split('&&').each do |control_element|
            check_element(control_element.strip)
          end
        else
          check_result = false
          control_ids.split('||').each do |control_element|
            begin
              check_element(control_element.strip)
              check_result = true
              break
            rescue Selenium::WebDriver::Error::TimeOutError => ex
              next
            end
          end
          raise "#{control_ids} not exist" if not check_result
        end
        check_result
      end

    end # end of self
  end # end of InnerScreen
end # end of Pages

module Kernel
  def inner_screen
    Pages::InnerScreen
  end
end
