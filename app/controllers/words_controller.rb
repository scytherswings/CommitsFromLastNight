class WordsController < ApplicationController
  before_action :set_word, only: [:show]

  # GET /words
  # GET /words.json
  def index
    @words = Word.all.order(:id).paginate(page: params[:page])
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end
end
