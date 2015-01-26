class MatchesController < ApplicationController
	before_action :set_match, only: [:show, :edit, :update, :destroy]

	def index
		@matches = @season.matches.order(:playing_date)
	end

	def show
		@games = @match.games.order(:board_number)
	end

	def new
		@league = @season.leagues.find(params[:league_id]) if params[:league_id]
		@match = @league ? @league.matches.build : Match.new
		@match.black_team_id = params[:black_team_id]
		@match.white_team_id = params[:white_team_id]
		@leagues = @season.leagues
		@teams = @league ? @league.teams : Team.where(league_id: @leagues.pluck(:id))
	end

	def edit
		if @match.games.count < 3
			3.times do |i|
				if @match.games.find_by(board_number: i+1).nil?
					@match.games.create(board_number: i+1)
				end
			end
		end
		@games = @match.games.order(:board_number)
		if params[:all]
			@black_players = Participant.all
			@white_players = Participant.all
		else
			@black_players = Participant.where('club_id IN (?)', @match.black_team.club.teams.includes(team_members: :participant).map { |t| t.team_members.map { |m| m.participant.club_id } }.flatten)
			@white_players = Participant.where('club_id IN (?)', @match.white_team.club.teams.includes(team_members: :participant).map { |t| t.team_members.map { |m| m.participant.club_id } }.flatten)
		end
		@black_players = @black_players.order('rating DESC')
		@white_players = @white_players.order('rating DESC')
	end

	def create
		@match = Match.new(match_create_params)
		respond_to do |format|
			if @match.save
				format.html { redirect_to edit_match_url(@match), notice: 'Match was successfully created.' }
				format.json { render action: 'show', status: :created, location: @match }
			else
				format.html { render action: 'new' }
				format.json { render json: @match.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @match.update(match_update_params)
				format.html { redirect_to @match, notice: 'Match was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @match.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@match.destroy
		respond_to do |format|
			format.html { redirect_to matches_url }
			format.json { head :no_content }
		end
	end

	private
		def set_match
			@match = Match.find(params[:id])
		end

		def match_create_params
			params.require(:match).permit(:league_id, :venue_id, :playing_date, :playing_time, :black_team_id, :white_team_id)
		end

		def match_update_params
			params.require(:match).permit(:venue_id, :playing_date, :playing_time, games_attributes: [:id, :black_id, :white_id, :result])
		end
end
