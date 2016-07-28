# filename: ios/pages/my_account.rb

require_relative '../../common/requires'

module Pages
  module MyAccount
    class << self

      include Actions

      def button_My_Account
        @found_cell = wait { id 'btnMenuMyAccount' }
        self
      end

      def button_Login
        @found_cell = wait { id 'tablecellMyAccountLogin' }
        self
      end

      def statictext_System_Settings
        @found_cell = wait { id 'tablecellMyAccountSystemSettings' }
        self
      end

    end
  end
end

module Kernel
  def my_account
    Pages::MyAccount
  end
end
