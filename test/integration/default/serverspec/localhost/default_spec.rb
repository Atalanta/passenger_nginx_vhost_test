require 'spec_helper'

describe 'Passenger Nginx Vhost Test' do
  
  it 'should create a config snippet under sites available' do
    expect(file('/etc/nginx/sites-available/testapp')).to be_file
  end

  it 'should link the config into sites enabled' do
    expect(file('/etc/nginx/sites-enabled/testapp')).to be_linked_to '/etc/nginx/sites-available/testapp'
  end

  it 'should listen on port 80' do
    expect(file('/etc/nginx/sites-enabled/testapp').content).to match /^\s+listen 80 default_server;$/
  end

  it 'should use testapp.net as the server_name' do
    expect(file('/etc/nginx/sites-enabled/testapp').content).to match /^\s+server_name testapp.net;$/
  end

  it 'should enable passenger' do
    expect(file('/etc/nginx/sites-enabled/testapp').content).to match /^\s+passenger_enabled on;$/
  end

  it 'should use the production rails environment' do
    expect(file('/etc/nginx/sites-enabled/testapp').content).to match /^\s+rails_env\s+production;$/
  end

  it 'should set the document root to /home/deploy/testapp/current/public' do
    expect(file('/etc/nginx/sites-enabled/testapp').content).to match /^\s+root\s+\/home\/deploy\/testapp\/current\/public;$/
  end

  it 'should remove the default nginx vhost' do
    expect(file('/etc/nginx/sites-enabled/default')).not_to be_file
  end

  it 'should drop off an SSL cert for the testapp vhost' do
    expect(file('/etc/nginx/ssl/testapp.net.crt')).to be_file
    expect(file('/etc/nginx/ssl/testapp.net.key')).to be_file
  end

  it 'should serve HTTPS traffic encrypted with the test SSL cert' do
    expect((command 'echo | openssl s_client -connect localhost:443').stdout).to match /CN=testapp\.net/
  end
end
