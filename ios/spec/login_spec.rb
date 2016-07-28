# filename: ios/spec/login_spec.rb
require_relative '../../common/requires'

describe 'Login' do

  it 'with valid account' do
    # switch to My Account page
    my_account.button_My_Account.click
    inner_screen.has_control 'uiviewMyAccount'

    # enter login page
    my_account.button_Login.click
    inner_screen.has_control 'uiviewLogIn'

    # login
    login.field_Email_Address.type 'leo.lee@dji.com'
    login.field_Password.type '123321'
    login.button_Login.click
    inner_screen.has_control 'tablecellMyMessage'
  end

end
