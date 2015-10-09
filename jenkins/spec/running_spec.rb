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

  it 'should have state running' do
    expect(@container.json["State"]["Running"]).to be true
  end

  it 'should have ansible installed' do
    expect(package('ansible')).to be_installed
  end

  it 'should have rvm and ruby 2.1.2 installed and available for jenkins' do
    expect(command('su - jenkins -c "ruby -v"').stdout).to match(/2\.1\.2/)
  end

  it 'should have jenkins and nginx installed' do
    expect(package('jenkins')).to be_installed
    expect(package('nginx')).to be_installed
  end

  it 'should have jenkins listening on port 8080 only localhost' do
    sleep 1 until command('netstat -tulapn').stdout.match(/:8080/)
    expect(command('netstat -tulapn').stdout).to match(/127.0.0.1:8080/)
  end

  it 'should run jenkins and nginx as a non privileged user' do 
    expect(command('ps -u jenkins').exit_status).to eq 0
    expect(command('ps -u www-data').exit_status).to eq 0
  end

  it 'should be fully up and running' do
    sleep 1 until file('/var/log/jenkins/jenkins.log').content.match('INFO: Jenkins is fully up and running')
    expect(file('/var/log/jenkins/jenkins.log').content).to match('INFO: Jenkins is fully up and running')
  end

  it 'should not throw any WARNING or SEVERE message in Jenkins Logs' do
    expect(file('/var/log/jenkins/jenkins.log').content).to_not match(/WARNING|SEVERE/)
  end

  it 'should return the Welcome Jenkins page on port 80 ' do
    expect(command("curl -s localhost|grep 'Welcome to Jenkins!'").exit_status).to eq 0
  end
 
  it "should have all the processes stay RUNNING" do
    expect(@container.logs(stdout: true)).to_not match(/exit/)
  end

  # Helper functions

  def os_version
    command("lsb_release -a").stdout
  end

end
