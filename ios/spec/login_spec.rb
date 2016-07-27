# filename: ios/spec/login_spec.rb
require_relative '../../common/requires'

describe 'Login' do

  it 'with valid account' do
    wait { id('btnMenuMyAccount').click }
    wait { id 'uiviewMyAccount' }

    wait { id('tablecellMyAccountLogin').click }
    wait { id 'uiviewLogIn' }

    wait { id('txtfieldEmailAddress').type 'leo.lee@dji.com' }
    wait { id('sectxtfieldPassword').type '123321' }
    wait { id('btnLogin').click }
    wait { id 'tablecellMyMessage' }
  end

end
