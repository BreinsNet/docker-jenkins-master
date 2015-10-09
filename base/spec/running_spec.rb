# spec/Dockerfile_spec.rb
require "spec_helper"

describe "Running it as a container" do

  before(:all) do
    @container = Docker::Container.create('Image' => $image_name).start

    # Check the logs, when it stops logging we can assume the container is fully up and running
    log_size_ary = []
    CONTAINER_RUN_WAIT_TIMEOUT.times do
      log_size_ary << @container.logs(stdout: true).size
      break if log_size_ary.last(3).sort.uniq.size == 1 && log_size_ary.last(3).sort.uniq.last > 0
      sleep 1
    end

    set :docker_container, @container.id
  end

  after(:all) do
    @container.kill
    @container.delete(:force => true)
  end

  it "should be available" do
    expect($image).to_not be_nil
  end

  it "use ubuntu 14.04" do
    expect(os_version).to include("Ubuntu 14")
  end

  it 'should have state running' do
    expect(@container.json["State"]["Running"]).to be true
  end

 
  it 'should have debug tools installed' do
    expect(file('/usr/bin/telnet')).to exist
    expect(file('/usr/bin/vmstat')).to exist
    expect(file('/usr/bin/iostat')).to exist
    expect(file('/usr/bin/wget')).to exist
    expect(file('/usr/bin/rsync')).to exist
    expect(file('/usr/bin/git')).to exist
    expect(file('/usr/bin/strace')).to exist
    expect(file('/usr/bin/pwgen')).to exist
    expect(file('/usr/bin/traceroute')).to exist
    expect(file('/usr/bin/htop')).to exist
    expect(file('/usr/sbin/iotop')).to exist
    expect(file('/usr/bin/curl')).to exist
  end

  it "should have all the processes stay RUNNING" do
    expect(@container.logs(stdout: true)).to_not match(/exit/)
  end

  # Helper functions

  def os_version
    command("lsb_release -a").stdout
  end

end
