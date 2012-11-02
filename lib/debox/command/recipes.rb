require 'debox/command/base'

class Debox::Command::Recipes < Debox::Command::Base
  include Debox::Utils


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


end
