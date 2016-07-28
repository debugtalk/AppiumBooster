# filename: ios/spec/login_spec.rb
require_relative '../../common/requires'

describe 'Settings' do

  it 'switch country to China' do
    # switch to My Account page
    my_account.button_My_Account.click
    inner_screen.has_control 'uiviewMyAccount'

    # enter settings
    my_account.statictext_System_Settings.click
    inner_screen.has_control 'txtCountryDistrict'

    # enter country district
    settings.statictext_Country_District.click
    inner_screen.has_control 'uiviewSelectCountry'

    # select country
    select_country.selectCountry('tablecellSelectCN').click
    inner_screen.has_control 'txtCountryDistrict'
  end

end
