require 'spec_helper'

describe 'delete recipe' do
  it 'should call API::recipes_destroy' do
    Debox::API.should_receive(:recipes_destroy).with(app: 'test', env: 'prod')
    run_command 'recipes:delete test prod'
  end
end
