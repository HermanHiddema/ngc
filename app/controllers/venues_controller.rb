class VenuesController < ApplicationController
	before_action :set_venue, only: [:show, :edit, :update, :destroy]

	def index
		@venues = Venue.all
		@venues = @venues.order(:city)
	end

	def show
		@matches = @venue.matches.joins(:league).where(leagues: { season_id: @season })
	end

	def new
		@venue = Venue.new
	end

	def edit
	end

	def create
		@venue = Venue.new(venue_params)

		respond_to do |format|
			if @venue.save
				format.html { redirect_to @venue, notice: 'Venue was successfully created.' }
				format.json { render action: 'show', status: :created, location: @venue }
			else
				format.html { render action: 'new' }
				format.json { render json: @venue.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @venue.update(venue_params)
				format.html { redirect_to @venue, notice: 'Venue was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @venue.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@venue.destroy
		respond_to do |format|
			format.html { redirect_to venues_url }
			format.json { head :no_content }
		end
	end

	private
		def set_venue
			@venue = Venue.find(params[:id])
		end

		def venue_params
			params.require(:venue).permit(:club_id, :name, :address, :city, :playing_day, :playing_time, :info)
		end
end
