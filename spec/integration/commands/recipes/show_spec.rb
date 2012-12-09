require 'spec_helper'

describe 'recipes' do
  it 'should call API::recipes' do
    Debox::API.should_receive(:recipes_show).with(app: 'test', env: 'prod').and_return 'recipe content'
    run_command 'recipes:show test prod'
  end
end
