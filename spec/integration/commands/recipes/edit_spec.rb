require 'spec_helper'

describe 'recipes edit' do
  before :each do
    @content = 'recipe content'
    @edited_content = 'edited content'
    @args = { app: 'test', env: 'prod'}
  end
  it 'should ignore update if the recipe does not change' do
    Debox::API.should_receive(:recipes_show).with(@args).and_return @content
    Debox::Command::Recipes.any_instance.should_receive(:edit_file).with(@content).and_return(@content)
    Debox::API.should_not_receive :recipes_update
    run_command 'recipes:edit test prod'
  end

  it 'should update the recipe if the content change' do
    Debox::API.should_receive(:recipes_show).with(@args).and_return @content
    Debox::Command::Recipes.any_instance.should_receive(:edit_file).with(@content).and_return(@edited_content)
    Debox::API.should_receive(:recipes_update).with(@args.merge content: @edited_content)
    run_command 'recipes:edit test prod'

  end
end
