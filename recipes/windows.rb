if node.platform_family?("windows")
  arch = node['kernel']['machine']
  #puts "Arch is #{arch}"
  path = ""
  display_name = ""

  if arch.include?("_64")
    path = "x86_64"
    display_name = "Boundary Meter (x64 edition)"
  elsif arch.include?("i386")
    path = "i686"
    display_name = "Boundary Meter (x86 edition)"
  end


  windows_package "#{display_name}" do
    source "https://windows.boundary.com/#{path}/bprobe-current.msi"
    options "/l*v bprobe.log INSTALLTOKEN=#{node[:boundary][:api][:org_id]}:#{node[:boundary][:api][:key]}"
    action :install
  end

  service "bprobe" do
    action [ :start, :enable ]
  end
end