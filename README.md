### The bprobe Cookbook

This cookbook has two functions, the first is to install the Boundary bprobe daemon on your machine. The second is to interface with the Boundary API providing bprobe with certificates, adding the meter to your account and adding the meter to a group. The latter is provided by two LWRP's bprobe and bprobe_certificates. Examples of their usage can be found in the default recipe. This recipe can be used as is to install bprobe and configure it using the Boundary API. To get things running adjust the attributes in api.rb to match your Boundary account, upload the cookbooks in this repo and apply bprobe::default to a system.

##### Dependencies

        sudo gem install json excon --no-rdoc --no-ri

##### API Keys

Setup your API keys in attributes/api.rb