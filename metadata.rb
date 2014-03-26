name             "bprobe"
maintainer       "Boundary"
maintainer_email "ops@boundary.com"
license          "Apache 2.0"
description      "Installs/Configures bprobe"
long_description "Installs/Configures bprobe"
version          "0.2"

%w{ ubuntu debian rhel centos amazon scientific }.each do |os|
  supports os
end

depends "yum", "<= 2.4.4"
depends "apt"
