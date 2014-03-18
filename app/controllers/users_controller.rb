require 'yaml'

class UsersController < ApplicationController
  def list
    alias_search = "#{params[:alias]}%"

    per_page = 20

    all_users = User.where("alias LIKE :search", search: alias_search).order("#{sort_column} #{sort_direction}")
    page = [[(all_users.count.to_f / per_page.to_f).ceil, params[:page].to_i].min, 1].max

    @users = all_users.paginate(:page => page, :per_page => per_page)
  end

  def export
    unless request.format == 'sql'
      data = User.includes(:loans).to_a.map do |user|
        user.serializable_hash.merge({ :loans => user.loans.includes(:investments).to_a.map { |loan|
            loan.serializable_hash.merge({ :investments => loan.investments.to_a.map(&:serializable_hash) })
          }
        })
      end
    end

    respond_to do |format|
      format.xml { render xml: data.to_xml }
      format.json { render json: data.to_json }
      format.yaml { render text: data.to_yaml, :format => 'text/yaml' }
      format.sql { render text: `mysqldump --single-transaction --add-drop-table -u jammer --password=#{Rails.configuration.database_configuration[Rails.env]['password']} #{Rails.configuration.database_configuration[Rails.env]['database']}`, :format => 'text/sql' }
    end
  end
end
