#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Recipe:: dependencies
#
# Copyright 2011, Boundary
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# excon and json for meter lwrp
gem_package "excon"
gem_package "json"

case node[:platform]
when "redhat", "centos"

  yum_key "RPM-GPG-KEY-boundary" do
    url "https://yum.boundary.com/RPM-GPG-KEY-Boundary"
    action :add
  end

  yum_repository "boundary" do
    name "boundary repo"
    url "https://yum.boundary.com/centos/os/5.5/x86_64/"
    key "RPM-GPG-KEY-boundary"
    action :add
  end

when "debian", "ubuntu"

  apt_repository "boundary" do
    uri "https://apt.boundary.com/ubuntu/"
    distribution node['lsb']['codename']
    components ["universe"]
    key "https://apt.boundary.com/APT-GPG-KEY-Boundary"
    action :add
  end

end

