class TeamsController < ApplicationController
	before_action :set_team, only: [:show, :edit, :update, :destroy]

	def index
		@teams = Team.all.includes(:league, :club, team_members: :participant).order(:name)
	end

	def show
		@members = @team.team_members.joins(:participant).order('rating DESC')
		@matches = @team.matches.order(:playing_date)
	end

	def new
		@team = Team.new
		3.times do |i| 
			@team.team_members.build(board_number: i+1)
		end
	end

	def edit
		(3 - @team.team_members.count).times do |i|
			@team.team_members.build(board_number: i+1+@team.team_members.count)
		end
		@members = @team.team_members
	end

	def create
		@team = Team.new(team_params)

		respond_to do |format|
			if @team.save
				format.html { redirect_to @team, notice: 'Team was successfully created.' }
				format.json { render action: 'show', status: :created, location: @team }
			else
				format.html { render action: 'new' }
				format.json { render json: @team.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @team.update(team_params)
				format.html { redirect_to @team, notice: 'Team was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @team.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		@team.destroy
		respond_to do |format|
			format.html { redirect_to teams_url }
			format.json { head :no_content }
		end
	end

	private
		def set_team
			@team = Team.find(params[:id])
		end

		def team_params
			params.require(:team).permit(:name, :abbrev, :club_id, :league_id, team_members_attributes: [:id, :board_number, :participant_id])
		end
end
