class FilterWordsController < ApplicationController
  before_action :set_filter_word, only: [:show, :edit, :update, :destroy]

  # GET /filter_words
  # GET /filter_words.json
  def index
    @filter_words = FilterWord.all
  end

  # GET /filter_words/1
  # GET /filter_words/1.json
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_filter_word
    @filter_word = FilterWord.find(params[:id])
  end
end
