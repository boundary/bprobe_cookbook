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

case node[:platform_family]
when "rhel"

  yum_repository "boundary" do
    description "boundary"
    baseurl node[:boundary][:bprobe][:yum][:uri]
    gpgkey node[:boundary][:bprobe][:yum][:key]
    action :add
  end

when "debian"

  package "apt-transport-https"

  apt_repository "boundary" do
    uri node[:boundary][:bprobe][:apt][:uri]
    distribution node[:lsb][:codename]
    components ["universe"]
    key node[:boundary][:bprobe][:apt][:key]
    action :add
  end
end

cookbook_file "#{Chef::Config[:file_cache_path]}/cacert.pem" do
  source "cacert.pem"
  mode 0600
  owner "root"
  group "root"
end
