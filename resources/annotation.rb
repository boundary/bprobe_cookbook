# Author:: Joe Williams (<j@boundary.com>)
# Author:: Christian Vozar (<christian@bellycard.com>)
# Cookbook Name:: bprobe
# Resource:: annotation
#
# Copyright 2011, Boundary
# Copyright 2013, Belly, Inc.
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

actions :create, :create_opsworks
default_action :create

attribute :name, :kind_of => String, :name_attribute => true, :required => true
attribute :subtype, :kind_of => String, :default => "chef"
attribute :start_time, :kind_of => Integer, :default => Time.now.to_i
attribute :end_time, :kind_of => Integer, :default => Time.now.to_i
attribute :tags, :kind_of => Array, :default => []