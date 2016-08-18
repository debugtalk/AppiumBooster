## AppiumBooster

AppiumBooster helps you to write automation testcases in yaml format or csv tables, without writing a snippet of code.

## write testcases in yaml (recommended)

Take DJI+ Discover's login and logout function as an example.

![](examples/preview_login_and_logout.png)

In order to test these functions above, you can write testcases in yaml format like this.

```yaml
# ios/testcases/Account.yml
---
AccountTestcases:
  login with valid account:
    - AccountSteps | enter My Account page
    - AccountSteps | enter Login page
    - AccountSteps | input EmailAddress
    - AccountSteps | input Password
    - AccountSteps | login
    - AccountSteps | close coupon popup window(optional)

  logout:
    - AccountSteps | enter My Account page
    - SettingsSteps | enter Settings page
    - AccountSteps | logout
```

In the testcases, each step is combined with two parts, joined by a separator `|`. The former part indicates step file located in `ios/steps/` directory, and the latter part indicates testcase step name, which is defined in steps yaml files like below.

```yaml
# ios/steps/AccountSteps.yml
---
AccountSteps:
  enter My Account page:
    control_id: btnMenuMyAccount
    control_action: click
    expectation: tablecellMyAccountSystemSettings

  enter Login page:
    control_id: tablecellMyAccountLogin
    control_action: click
    expectation: btnForgetPassword

  input EmailAddress:
    control_id: txtfieldEmailAddress
    control_action: type
    data: leo.lee@debugtalk.com
    expectation: sectxtfieldPassword

  input Password:
    control_id: sectxtfieldPassword
    control_action: type
    data: 123456
    expectation: btnLogin

  login:
    control_id: btnLogin
    control_action: click
    expectation: tablecellMyMessage
```

## write testcases in tables

You can also write testcases in any table tools, including MS Excel and iWork Numbers, and even in plain CSV format.

In order to test the same functions above, you can write testcases in tables like this.

![](examples/testcase_login_and_logout.png)

After the testcases are finished, export to CSV format, and put the csv files under `ios/testcases/` directory.

## run

Once the testcases are done, you are ready to run automation test on your app.

Run the automation testcases is very easy. You can execute `ruby run.rb -h` in the project root directory to see the usage.

```
➜  AppiumBooster git:(master) ✗ ruby run.rb -h
Usage: run.rb [options]
    -p, --app_path <value>           Specify app path
    -t, --app_type <value>           Specify app type, ios or android
    -f, --testcase_file <value>      Specify testcase file
        --disable_output_color       Disable output color
```

AppiumBooster will load all the csv test suites and then excute each suite sequentially.

```
➜  AppiumBooster git:(master) ✗ ruby run.rb -p "ios/app/test.zip" -f "ios/testcases/Account.yml"
initialize appium driver ...
load testcase yaml file: /Users/Leo/MyProjects/AppiumBooster/ios/testcases/Account.yml
load steps yaml file: /Users/Leo/MyProjects/AppiumBooster/ios/steps/AccountSteps.yml
load steps yaml file: /Users/Leo/MyProjects/AppiumBooster/ios/steps/SettingsSteps.yml
start appium driver ...

======= start to run testcase suite: /Users/Leo/MyProjects/AppiumBooster/ios/testcases/Account.yml =======
B------ Start to run testcase: login with valid account
step_1: enter My Account page
btnMenuMyAccount.click     ...    ✓
step_2: enter Login page
tablecellMyAccountLogin.click     ...    ✓
step_3: input EmailAddress
txtfieldEmailAddress.type leo.lee@debugtalk.com    ...    ✓
step_4: input Password
sectxtfieldPassword.type 123456    ...    ✓
step_5: login
btnLogin.click     ...    ✓
step_6: close coupon popup window(optional)
btnClose.click     ...    ✓
E------ login with valid account

B------ Start to run testcase: logout
step_1: enter My Account page
btnMenuMyAccount.click     ...    ✓
step_2: enter Settings page
tablecellMyAccountSystemSettings.click     ...    ✓
step_3: logout
btnLogout.click     ...    ✓
E------ logout

============ all testcases have been executed. ============
quit appium driver.
```
