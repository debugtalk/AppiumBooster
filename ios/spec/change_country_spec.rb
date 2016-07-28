# filename: ios/spec/change_country_spec.rb
require_relative '../../common/requires'

describe 'Change country' do

  it 'from Hong Kong to China' do
    wait { id('btnMenuMyAccount').click }
    wait { id 'uiviewMyAccount' }

    wait { id('tablecellMyAccountSystemSettings').click }
    wait { id 'txtCountryDistrict' }

    wait { id('txtCountryDistrict').click }
    wait { id 'uiviewSelectCountry' }

    wait { id('tablecellSelectCN').click }

    wait { id('btnArrowLeft').click }
    wait { id 'uiviewMyAccount' }
  end

end
