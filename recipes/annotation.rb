#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Recipe:: annotation
#
# Copyright 2012, Boundary
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

# example recipe for creating an boundary annotation

bprobe_annotation "chef annotation" do
  action :create
  subtype "test"
  tags ["tag1", "tag2"]
end

# example for creating an annoation based on opsworks data
# this provider will ignore the type and subtype you specify and use its own
# additionally it will use your tags and add some from opsworks data automatically

bprobe_annotation "opsworks" do
  action :create_opsworks
end