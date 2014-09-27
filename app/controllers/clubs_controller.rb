class ClubsController < ApplicationController
	before_action :set_club, only: [:show, :edit, :update, :destroy]

	def index
		@clubs = Club.where('LENGTH(name) > 4')
		@clubs = Club.all if params[:all]
	end

	def show
		@participants = @club.participants.order('rating DESC')
		@teams = @club.teams.includes(:league, :club).order(:name)
		@matches = Match.where('black_team_id in (?) OR white_team_id in (?)', @teams.pluck(:id), @teams.pluck(:id)).order(:playing_date, :playing_time)
	end

	def new
		@club = Club.new
	end

	def edit
	end

	def create
		@club = Club.new(club_params)

		respond_to do |format|
			if @club.save
				format.html { redirect_to @club, notice: 'Club was successfully created.' }
				format.json { render action: 'show', status: :created, location: @club }
			else
				format.html { render action: 'new' }
				format.json { render json: @club.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @club.update(club_params)
				format.html { redirect_to @club, notice: 'Club was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @club.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@club.destroy
		respond_to do |format|
			format.html { redirect_to clubs_url }
			format.json { head :no_content }
		end
	end

	private
		def set_club
			@club = Club.find(params[:id])
		end

		def club_params
			params.require(:club).permit(:name, :abbrev, :contact_person_id, :website, :info)
		end
end
