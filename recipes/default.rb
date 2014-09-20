#
# Cookbook Name:: passenger_nginx_vhost_test
# Recipe:: default
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

include_recipe 'passenger_nginx'

passenger_nginx_vhost 'testapp' do
  action :create
  port 80
  server_name 'testapp.net'
  environment 'production'
  root '/home/deploy/testapp/current/public'
end
