class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

	before_action :set_current_season

	def set_current_season
		if request.host =~ /^((voor|na)jaar-\d{4})\.(.*)/
			season_name = $1.capitalize.gsub('-',' ')
			@season = Season.find_by_name(season_name)
			@host = $2
		end

		@season ||= Season.last
		@host ||= request.host.gsub('www.','')
		@port = request.port
	end

	def require_admin!
		head :unauthorized
	end

end
