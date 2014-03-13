class UsersController < ApplicationController
  def list
    alias_search = "#{params[:alias]}%"
    @users = User.where("alias LIKE :search", search: alias_search).order('id desc').paginate(:page => params[:page], :per_page => 20)
  end
end
