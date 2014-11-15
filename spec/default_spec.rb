require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|

  config.platform = 'ubuntu'
  config.version = '14.04'

  describe 'passenger_nginx_test::default' do

    before(:each) do
      stub_command(/apt-key list/).and_return(false)
      stub_command(/ruby-switch/).and_return(false)
    end

    let(:chef_run) { ChefSpec::Runner.new(step_into: ['passenger_nginx_vhost']).converge('passenger_nginx_vhost_test::default') }

    it 'disables the default virtual host' do
      link = chef_run.link('/etc/nginx/sites-enabled/default')
      expect(link.action).to include(:delete)
    end
    
    it 'creates a passenger virtual host' do
      expect(chef_run).to render_file('/etc/nginx/sites-available/testapp')
    end
    
    it 'enables the virtual host' do
      link = chef_run.link('/etc/nginx/sites-enabled/testapp')
      expect(link).to link_to('/etc/nginx/sites-available/testapp')
    end
    
    it 'creates a testapp SSL cert' do
      expect(chef_run).to render_file('/etc/nginx/ssl/testapp.net.crt')
      expect(chef_run).to render_file('/etc/nginx/ssl/testapp.net.key')
    end

    it 'sets the SSL cert directive in line with vhost name' do
      ssl_directive = /ssl_certificate.*testapp.*crt/
      expect(chef_run).to render_file('/etc/nginx/sites-available/testapp').with_content ssl_directive
    end
    
    it 'configures the vhost with provided parameters' do
      parameters = { 
        listen: /^\s+listen 80 default_server;$/,
        server_name: /^\s+server_name testapp.net;$/,
        passenger_enabled: /^\s+passenger_enabled on;$/,
        rails_env: /^\s+rails_env\s+production;$/,
        root: /^\s+root\s+\/home\/deploy\/testapp\/current\/public;$/
      }
      parameters.each do |param, value|
        expect(chef_run).to render_file('/etc/nginx/sites-available/testapp').with_content value
      end
    end
  end
end



