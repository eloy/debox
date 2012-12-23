require 'spec_helper'

describe 'recipes' do
  it 'should call API::recipes' do
    Debox::API.should_receive(:recipes).with(app: 'test').and_return []
    run_command 'recipes test'
  end
end
