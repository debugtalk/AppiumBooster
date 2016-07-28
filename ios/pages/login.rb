# filename: ios/pages/login.rb

require_relative '../../common/requires'

module Pages
  module Login
    class << self

      include Actions

      def field_Email_Address
        @found_cell = wait { id 'txtfieldEmailAddress' }
        self
      end

      def field_Password
        @found_cell = wait { id 'sectxtfieldPassword' }
        self
      end

      def button_Login
        @found_cell = wait { id 'btnLogin' }
        self
      end

    end
  end
end

module Kernel
  def login
    Pages::Login
  end
end
