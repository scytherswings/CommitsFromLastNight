class BlackListWordsController < ApplicationController
  before_action :set_black_list_word, only: [:show, :edit, :update, :destroy]

  # GET /black_list_words
  # GET /black_list_words.json
  def index
    @black_list_words = BlackListWord.all
  end

  # GET /black_list_words/1
  # GET /black_list_words/1.json
  def show
  end

  # GET /black_list_words/new
  def new
    @black_list_word = BlackListWord.new
  end

  # GET /black_list_words/1/edit
  def edit
  end

  # POST /black_list_words
  # POST /black_list_words.json
  def create
    @black_list_word = BlackListWord.new(black_list_word_params)

    respond_to do |format|
      if @black_list_word.save
        format.html { redirect_to @black_list_word, notice: 'Black list word was successfully created.' }
        format.json { render :show, status: :created, location: @black_list_word }
      else
        format.html { render :new }
        format.json { render json: @black_list_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /black_list_words/1
  # PATCH/PUT /black_list_words/1.json
  def update
    respond_to do |format|
      if @black_list_word.update(black_list_word_params)
        format.html { redirect_to @black_list_word, notice: 'Black list word was successfully updated.' }
        format.json { render :show, status: :ok, location: @black_list_word }
      else
        format.html { render :edit }
        format.json { render json: @black_list_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /black_list_words/1
  # DELETE /black_list_words/1.json
  def destroy
    @black_list_word.destroy
    respond_to do |format|
      format.html { redirect_to black_list_words_url, notice: 'Black list word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_black_list_word
      @black_list_word = BlackListWord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def black_list_word_params
      params.require(:black_list_word).permit(:word)
    end
end
