class SeasonsController < ApplicationController
	before_action :set_season, only: [:show, :edit, :update, :destroy]
	before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]
	respond_to :text

	def index
		@seasons = Season.all
	end

	def show
		respond_with do |format|
			format.text { render text: @season.results.join("\n") }
			format.html { redirect_to leagues_url }
		end
	end

	def new
		@season = Season.new
	end

	def edit
	end

	def create
		@season = Season.new(season_params)

		respond_to do |format|
			if @season.save
				format.html { redirect_to @season, notice: 'Season was successfully created.' }
				format.json { render action: 'show', status: :created, location: @season }
			else
				format.html { render action: 'new' }
				format.json { render json: @season.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @season.update(season_params)
				format.html { redirect_to @season, notice: 'Season was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @season.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@season.destroy
		respond_to do |format|
			format.html { redirect_to seasons_url }
			format.json { head :no_content }
		end
	end

	private
		def set_season
			@season = Season.find(params[:id])
		end

		def season_params
			params.require(:season).permit(:name, :information)
		end
end
