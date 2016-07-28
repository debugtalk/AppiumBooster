# filename: ios/pages/select_country.rb

require_relative '../../common/requires'

module Pages
  module SelectCountry
    class << self

      include Actions

      def btn_Cancel
        @found_cell = wait { id 'btnCancel' }
        self
      end

      def selectCountry(country_name)
        @found_cell = wait { id country_name }
        self
      end

    end
  end
end

module Kernel
  def select_country
    Pages::SelectCountry
  end
end
