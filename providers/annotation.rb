#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Provider:: annotation
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

include Boundary::API

action :create do
  annotate(new_resource)
  new_resource.updated_by_last_action(true)
end

action :create_opsworks do
  create_opsworks_life_cycle_event_annotation(new_resource)
  new_resource.updated_by_last_action(true)
end
