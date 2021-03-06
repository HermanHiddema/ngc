class LeaguesController < ApplicationController
	before_action :set_league, only: [:show, :edit, :update, :destroy]

	def index
		@leagues = @season.leagues.order(:order).includes(:teams, matches: :games)
		@matches = @season.matches.includes(:black_team, :white_team, :games)
	end

	def show
		@participants = Participant.joins(:team_member).where('team_members.team_id' => @league.teams.pluck(:id))
		@participants = @participants.to_a.sort_by(&:rating_change).reverse
		@teams = @league.teams
		@matches = @league.matches.order(:playing_date, :playing_time)
		respond_to do |format|
			format.text { render text: @league.results.join("\n")}
			format.html
		end
	end

	def new
		@league = @season.leagues.build
	end

	def edit
	end

	def create
		@league = League.new(league_params)

		respond_to do |format|
			if @league.save
				format.html { redirect_to @league, notice: 'League was successfully created.' }
				format.json { render action: 'show', status: :created, location: @league }
			else
				format.html { render action: 'new' }
				format.json { render json: @league.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @league.update(league_params)
				format.html { redirect_to @league, notice: 'League was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @league.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@league.destroy
		respond_to do |format|
			format.html { redirect_to leagues_url }
			format.json { head :no_content }
		end
	end

	private
	def set_league
		@league = League.find(params[:id])
	end

	def league_params
		params.require(:league).permit(:name, :order, :season_id)
	end
end
