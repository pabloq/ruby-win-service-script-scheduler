# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rsscheduler'
require 'yaml'
describe RSScheduler do
  before(:each) do
    @rsscheduler = RSScheduler.new YAML::load_file("app_config.yml")
  end

  it "should be today date" do
    @rsscheduler.today.should == '20090127'
  end
end