#
# Author:: Joe Williams (<j@boundary.com>)
# Cookbook Name:: bprobe
# Library:: boundary_api
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

require 'json'
require 'excon'
require 'base64'

module Boundary
  module API

    def create_meter_request(new_resource)
      begin
        url = build_url(new_resource, :create)
        headers = generate_headers()
        body = {:name => new_resource.name}.to_json

        Chef::Log.info("Creating meter [#{new_resource.name}]")
        response = http_post_request(url, headers, body)

      rescue Exception => e
        Chef::Log.error("Could not create meter [#{new_resource.name}], failed with #{e}")
      end
    end

    def apply_meter_tags(new_resource)
      Chef::Log.debug("This meter currently has these tags [#{node[:boundary][:bprobe][:tags]}]")

      tags = new_resource.tags - node[:boundary][:bprobe][:tags]

      if tags.length > 0
        begin
          url = build_url(new_resource, :tags)
          headers = generate_headers()

          Chef::Log.info("Applying meter tags [#{new_resource.tags}]")

          tags.each do |tag|
            http_put_request("#{url}/#{tag}", headers, "")
          end
        rescue Exception => e
          Chef::Log.error("Could not apply meter tag, failed with #{e}")
        end
      else
        Chef::Log.debug("No meter tags to apply.")
      end
    end

    def delete_meter_request(new_resource)
      begin
        url = build_url(new_resource, :delete)
        headers = generate_headers()

        Chef::Log.info("Deleting meter [#{new_resource.name}]")
        response = http_delete_request(url, headers)

      rescue Exception => e
        Chef::Log.error("Could not delete meter [#{new_resource.name}], failed with #{e}")
      end
    end

    def save_meter_tags_attribute(new_resource)
      if Chef::Config[:solo]
        Chef::Log.debug("chef-solo run, not attempting to save tags attribute.")
      else
        begin
          node.set[:boundary][:bprobe][:tags] = new_resource.tags
          node.save
        rescue Exception => e
          Chef::Log.error("Could not save meter tags as node attribute, failed with #{e}")
        end
      end
    end

    def save_meter_id_attribute(new_resource)
      if Chef::Config[:solo]
        Chef::Log.debug("chef-solo run, not attempting to save id attribute.")
      else
        begin
          meter_id = get_meter_id(new_resource)

          if meter_id
            node.set[:boundary][:bprobe][:id] = meter_id
            node.save
          else
            Chef::Log.error("Could not save meter id as node attribute (nil response)!")
          end

        rescue Exception => e
          Chef::Log.error("Could not save meter id as node attribute, failed with #{e}")
        end
      end
    end

    def delete_meter_id_attribute
      if Chef::Config[:solo]
        Chef::Log.debug("chef-solo run, not attempting to delete attribute.")
      else
        begin
          if node[:boundary][:bprobe][:id]
            node[:boundary][:bprobe].delete(:id)
            node.save
          end
        rescue Exception => e
          Chef::Log.error("Could not delete meter id from node attributes, failed with #{e}")
        end
      end
    end

    def generate_headers()
      auth = auth_encode()
      {"Authorization" => "Basic #{auth}", "Content-Type" => "application/json"}
    end

    def auth_encode()
      auth = Base64.encode64("#{node[:boundary][:api][:key]}:").strip
      auth.gsub("\n","")
    end

    def build_url(new_resource, action)
      case action
      when :create
        "https://#{node[:boundary][:api][:hostname]}/#{node[:boundary][:api][:id]}/meters"
      when :search
        "https://#{node[:boundary][:api][:hostname]}/#{node[:boundary][:api][:id]}/meters?name=#{new_resource.name}"
      when :meter
        meter_id = get_meter_id(new_resource)
        "https://#{node[:boundary][:api][:hostname]}/#{node[:boundary][:api][:id]}/meters/#{meter_id}"
      when :certificates
        meter_id = get_meter_id(new_resource)
        "https://#{node[:boundary][:api][:hostname]}/#{node[:boundary][:api][:id]}/meters/#{meter_id}"
      when :delete
        meter_id = get_meter_id(new_resource)
        "https://#{node[:boundary][:api][:hostname]}/#{node[:boundary][:api][:id]}/meters/#{meter_id}"
      when :tags
        meter_id = get_meter_id(new_resource)
        "https://#{node[:boundary][:api][:hostname]}/#{node[:boundary][:api][:id]}/meters/#{meter_id}/tags"
      end
    end

    def meter_exists?(new_resource)
      begin
        url = build_url(new_resource, :search)
        headers = generate_headers()

        response = http_get_request(url, headers)

        if response
          body = JSON.parse(response.body)

          if body == []
            false
          else
            true
          end
        else
          Chef::Application.fatal!("Could not determine if meter exists (nil response)!")
        end
      rescue Exception => e
        Chef::Application.fatal!("Could not determine if meter exists, failed with #{e}")
      end
    end

    def get_meter_id(new_resource)
      begin
        url = build_url(new_resource, :search)
        headers = generate_headers()

        response = http_get_request(url, headers)

        if response
          body = JSON.parse(response.body)
          if body[0]
            if body[0]["id"]
              body[0]["id"]
            else
              Chef::Application.fatal!("Could not get meter id (nil response)!")
            end
          else
            Chef::Application.fatal!("Could not get meter id (nil response)!")
          end
        else
          Chef::Application.fatal!("Could not get meter id (nil response)!")
        end

      rescue Exception => e
        Chef::Application.fatal!("Could not get meter id, failed with #{e}")
        nil
      end
    end

    def http_get_request(url, headers)
      Chef::Log.debug("Url: #{url}")
      Chef::Log.debug("Headers: #{headers}")

      response = Excon.get(url, :headers => headers)

      Chef::Log.debug("Body: #{response.body}")
      Chef::Log.debug("Status: #{response.status}")

      if bad_response?(:get, url, response)
        nil
      else
        response
      end
    end

    def http_delete_request(url, headers)
      Chef::Log.debug("Url: #{url}")
      Chef::Log.debug("Headers: #{headers}")

      response = Excon.delete(url, :headers => headers)

      Chef::Log.debug("Body: #{response.body}")
      Chef::Log.debug("Status: #{response.status}")

      if bad_response?(:delete, url, response)
        nil
      else
        response
      end
    end


    def http_post_request(url, headers, body)
      Chef::Log.debug("Url: #{url}")
      Chef::Log.debug("Headers: #{headers}")

      response = Excon.post(url, :headers => headers, :body => body)

      Chef::Log.debug("Body: #{response.body}")
      Chef::Log.debug("Status: #{response.status}")

      if bad_response?(:post, url, response)
        nil
      else
        response
      end
    end

    def http_put_request(url, headers, body)
      Chef::Log.debug("Url: #{url}")
      Chef::Log.debug("Headers: #{headers}")

      response = Excon.put(url, :headers => headers, :body => body)

      Chef::Log.debug("Body: #{response.body}")
      Chef::Log.debug("Status: #{response.status}")

      if bad_response?(:put, url, response)
        nil
      else
        response
      end
    end

    def bad_response?(method, url, response)
      if response.status >= 400
        Chef::Application.fatal!("Got a #{response.status} for #{method} to #{url}")
        true
      else
        false
      end
    end

  end
end