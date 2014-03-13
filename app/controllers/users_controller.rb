require 'yaml'

class UsersController < ApplicationController
  def list
    alias_search = "#{params[:alias]}%"

    @users = User.where("alias LIKE :search", search: alias_search).order('id desc').paginate(:page => params[:page], :per_page => 20)
  end

  def export
    data = User.all.map{ |u| {:alias => u.alias, :profile => u.profile_url } }
    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.json { render json: data.to_json }
      format.yaml { render text: data.to_yaml, :format => 'text/yaml' }
    end
  end
end
