#
# Cookbook Name:: redis
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'redis::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(step_into: ['redis'])
      runner.converge(described_recipe)
    end

    let(:version) { '2.8.9' }

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'updates the package repository' do
      expect(chef_run).to run_execute('apt-get update')
    end

    it 'installs the necessary packages' do
      expect(chef_run).to install_package('build-essential')
      expect(chef_run).to install_package('tcl8.5')
    end

    it 'install redis' do
      expect(chef_run).to install_redis('2.8.9')
    end

    it 'retreives the application from source code' do
      expect(chef_run).to create_remote_file("/tmp/redis-#{version}.tar.gz")
    end

    it 'unzips the application' do
      resource = chef_run.remote_file("/tmp/redis-#{version}.tar.gz")
      expect(resource).to notify('execute[unzip_redis_archive]').to(:run).immediately
    end

    it 'builds and installs the application' do
      resource = chef_run.execute('unzip_redis_archive')
      expect(resource).to notify('execute[build_and_install_redis]').to(:run).immediately
    end

    it 'installs the server' do
      resource = chef_run.execute('build_and_install_redis')
      expect(resource).to notify('execute[install_server_redis]').to(:run).immediately
    end

    it 'starts the service' do
      expect(chef_run).to start_service('redis_6379')
    end
  end
end
