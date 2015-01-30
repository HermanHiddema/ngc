class GamesController < ApplicationController
	before_action :set_game, only: [:show, :edit, :update, :destroy]

	def index
		@games = @season.games
	end

end
