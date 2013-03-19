### The bprobe Cookbook

This cookbook has two functions, the first is to install the Boundary bprobe daemon on your machine. The second is to interface with the Boundary API providing bprobe with certificates, adding the meter to your account and adding the meter to a group. The latter is provided by two LWRP's bprobe and bprobe_certificates. Examples of their usage can be found in the default recipe. This recipe can be used as is to install bprobe and configure it using the Boundary API. To get things running adjust the attributes in api.rb to match your Boundary account, upload the cookbooks in this repo and apply bprobe::default to a system.


#### Dependencies

This cookbook depends on the `apt` and `yum` cookbooks from https://github.com/boundary/boundary_cookbooks The Opscode maintained versions of these cookbooks *should* also work.

##### API Keys

Setup your API keys in attributes/api.rb

````
default[:boundary][:api][:hostname] = "api.boundary.com"
default[:boundary][:api][:org_id] = "dlekd93DGJDJw9diekd98"
default[:boundary][:api][:key] = "PI1ldnfKENFMslekd29dl"
````

##### Host Tags

The easiest way to set host tags is to use override_attributes in your server roles

````
name "db-server"
description "Installs Boundary bprobe and sets some meter tags"
recipes "mysql","bprobe::default"

override_attributes({
  :boundary => {
    :bprobe => {
      :tags => [ "linux", "ubuntu", "database-server" ]
    }
  }
})
````

##### Annotations

You can create annotations in the Boundary dashboard using this cookbook as well. By default this cookbook will create an annotation on installing and uninstalling bprobe.

If you would like to create annotations at other times and in other cookbooks you need to depend on this one and use the `bprobe_annotation` LWRP. Something like the following:

````
bprobe_annotation "chef annotation" do
  action :create
  subtype "test"
  tags ["tag1", "tag2"]
end
````

You can find further examples in the `annotation.rb` recipe.

##### EC2

This cookbook includes automatic detection and tagging of your meter with various EC2 attributes such as security group and instance type.

##### OpsWorks

If you are using OpsWorks this cookbook should work out of the box (with the above dependencies). This cookbook also includes automatic detection and tagging of your meter with layers, stack name and applications if any exist.
