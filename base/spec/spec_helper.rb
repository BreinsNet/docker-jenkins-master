require "serverspec"
require "docker"
require "pry"
require "timeout"
require "highline/import"
require "popen4"
require "popen4"
require "colorize"

# Global constant variables:
CONTAINER_TIMEOUT = 10
CONTAINER_RUN_WAIT_TIMEOUT = 60
REPOSITORY_ID = 'breinsnet'

# Build the image name:
$image_name = REPOSITORY_ID + "/" + Dir.pwd.split('source/').last.gsub('/','-')

# Root file system operations
if ENV["DT_REBUILD_ROOT"] != "false"
  if ENV["DT_REBUILD_ROOT"] == "true" || agree("Do you want to rebuild the root filesystem? "){|q| q.default = 'y'}
    command = "bash -ec 'sudo chown root:root -R root/* && cd root && sudo tar zcf .root.tar.gz * && cd ../ && sudo mv root/.root.tar.gz .;sudo chown -R `id -u`:`id -g` root/*'"
    if !system command
      puts "ERROR: could not execute: #{command}"
      exit 1
    end
  end
end

# Expire the cache 
if ENV["DT_NO_CACHE"] != "false"
  if !ENV["DT_NO_CACHE"] == "true" || agree("Do you want to expire cache layers when building this image? ") {|q| q.default = 'n'}
    docker_build_args = '--no-cache'
  end
end

# Build the image
cmd = "docker build -t #{$image_name} #{docker_build_args} ."

status = POpen4::popen4(cmd) do |stdout, stderr, stdin|  
  stdout.each do |line|  
    puts line  
  end  
  stderr.each do |line|  
    puts line.red
  end  
end  

Kernel.exit! 1 if status.exitstatus != 0

# Get the image ID
$image = Docker::Image.all().detect {|i| i.info['RepoTags'].include? $image_name + ":latest" }
set :backend, :docker
