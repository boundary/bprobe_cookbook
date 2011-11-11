#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Provider:: default
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
  if node[:boundary][:bprobe][:id]
    Chef::Log.debug("Boundary meter already exists, not creating.")
  else
    create_meter_request(new_resource)
    save_meter_id_attribute(new_resource)
  end
end

action :delete do
  if meter_exists?(new_resource)
    delete_meter_request(new_resource)
    delete_meter_id_attribute
  else
    Chef::Log.debug("Boundary meter doesn't exist, not deleting.")
  end
end

private

def create_meter_request(new_resource)
  begin
    url = build_url(new_resource, :create)
    auth = auth_encode(new_resource)
    headers = {"Authorization" => "Basic #{auth}", "Content-Type" => "application/json"}
    body = {:name => new_resource.name}.to_json
          
    Chef::Log.info("Creating meter [#{new_resource.name}]")
    response = http_post_request(url, headers, body)
      
  rescue Exception => e
    Chef::Log.error("Could not create meter [#{new_resource.name}], failed with #{e}")
  end
end

def delete_meter_request(new_resource)
  begin
    url = build_url(new_resource, :delete)
    auth = auth_encode(new_resource)
    headers = {"Authorization" => "Basic #{auth}"}
  
    Chef::Log.info("Deleting meter [#{new_resource.name}]")
    response = http_delete_request(url, headers)
      
  rescue Exception => e
    Chef::Log.error("Could not delete meter [#{new_resource.name}], failed with #{e}")
  end
end