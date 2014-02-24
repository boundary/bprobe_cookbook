if node.platform_family?("windows")
  arch = node['kernel']['machine']
  path = ""
  display_name = ""

  if arch.include?("_64")
    path = "x86_64"
    display_name = "Boundary Meter (x64 edition)"
  elsif arch.include?("i386")
    path = "i686"
    display_name = "Boundary Meter (x86 edition)"
  end

  service "bprobe" do
    action [ :stop, :disable]
  end

  windows_package "#{display_name}" do
    action :remove
  end

  bprobe node[:fqdn] do
    action :delete
  end
end