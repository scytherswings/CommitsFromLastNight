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

  # GET /filter_words/new
  def new
    @filter_word = FilterWord.new
  end

  # GET /filter_words/1/edit
  def edit
  end

  # POST /filter_words
  # POST /filter_words.json
  def create
    @filter_word = FilterWord.new(filter_word_params)

    respond_to do |format|
      if @filter_word.save
        format.html { redirect_to @filter_word, notice: 'Filter word was successfully created.' }
        format.json { render :show, status: :created, location: @filter_word }
      else
        format.html { render :new }
        format.json { render json: @filter_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filter_words/1
  # PATCH/PUT /filter_words/1.json
  def update
    respond_to do |format|
      if @filter_word.update(filter_word_params)
        format.html { redirect_to @filter_word, notice: 'Filter word was successfully updated.' }
        format.json { render :show, status: :ok, location: @filter_word }
      else
        format.html { render :edit }
        format.json { render json: @filter_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filter_words/1
  # DELETE /filter_words/1.json
  def destroy
    @filter_word.destroy
    respond_to do |format|
      format.html { redirect_to filterWords_url, notice: 'Filter word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_filter_word
    @filter_word = FilterWord.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def filter_word_params
    params.require(:filter_word).permit(:word)
  end
end
