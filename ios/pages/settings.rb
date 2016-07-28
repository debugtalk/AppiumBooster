# filename: ios/pages/settings.rb

require_relative '../../common/requires'

module Pages
  module Settings
    class << self

      include Actions

      def statictext_Country_District
        @found_cell = wait { id 'txtCountryDistrict' }
        self
      end

    end
  end
end

module Kernel
  def settings
    Pages::Settings
  end
end
