require 'debox/command/base'

class Debox::Command::Recipes < Debox::Command::Base
  include Debox::Utils

  help :index, params: ['application'], text: 'List recipes for the application'
  def index
    app = args.first
    Debox::API.recipes(app: app).each do |recipe|
      puts recipe
    end
  end

  help :show, params: ['application', 'environment'], text: 'Show a new capistrano recipe'
  def show
    app = args.first
    env = args.last
    puts Debox::API.recipes_show app: app, env: env
  end

  help :new, params: ['application', 'environment'], text: 'Create a new capistrano recipe'
  def new
    app = args.first
    env = args.last
    new_recipe = Debox::API.recipes_new app: app, env: env
    md5 = md5_str new_recipe
    edited_recipe = edit_file new_recipe
    edited_md5 = md5_str edited_recipe
    if md5 == edited_md5
      exit_ok "No changes detected, nothing to update."
    end

    # Send changes back to the server
    notice "Updating changes in the server"
    Debox::API.recipes_create app: app, env: env, content: edited_recipe
    exit_ok "Recipe created"
  end

  help :edit, params: ['application', 'environment'], text: 'Edit a capistrano recipe'
  def edit
    app = args.first
    env = args.last
    recipe = Debox::API.recipes_show app: app, env: env
    md5 = md5_str recipe
    edited_recipe = edit_file recipe
    edited_md5 = md5_str edited_recipe
    if md5 == edited_md5
      exit_ok "No changes detected, nothing to update."
    end

    # Send changes back to the server
    notice "Updating changes in the server"
    Debox::API.recipes_update app: app, env: env, content: edited_recipe
    exit_ok "Recipe updated"
  end


  help :delete, params: ['application', 'environment'], text: 'Delete a capistrano recipe'
  def delete
    app = args.first
    env = args.last
    Debox::API.recipes_destroy app: app, env: env
    exit_ok "Recipe deleted"
  end

end
