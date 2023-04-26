Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "forwarded_port", guest: 8126, host: 8126
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
  end

  config.vm.provision "docker" do |docker|
    docker.build_image "./Dockerfile", args: "-t datadog-dbm"
    docker.run "datadog-dbm", args: "-d -p 8126:8126 --name datadog-dbm"
  end
end
