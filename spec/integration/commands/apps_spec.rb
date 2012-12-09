require 'spec_helper'

describe 'apps command' do
  it 'should call API::apps' do
    Debox::API.should_receive(:apps).and_return []
    run_command 'apps'
  end
end
