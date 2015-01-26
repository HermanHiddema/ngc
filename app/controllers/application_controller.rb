class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :authenticate_user!, only: [:new, :create, :edit, :update]

	before_action :set_current_season

	def set_current_season
		@season = Season.find(params[:season_id]) if params[:season_id]
		@season ||= Season.last
	end

end
