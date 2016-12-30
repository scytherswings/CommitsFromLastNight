class WhiteListWordsController < ApplicationController
  before_action :set_white_list_word, only: [:show, :edit, :update, :destroy]

  # GET /white_list_words
  # GET /white_list_words.json
  def index
    @white_list_words = WhiteListWord.all
  end

  # GET /white_list_words/1
  # GET /white_list_words/1.json
  def show
  end

  # GET /white_list_words/new
  def new
    @white_list_word = WhiteListWord.new
  end

  # GET /white_list_words/1/edit
  def edit
  end

  # POST /white_list_words
  # POST /white_list_words.json
  def create
    @white_list_word = WhiteListWord.new(white_list_word_params)

    respond_to do |format|
      if @white_list_word.save
        format.html { redirect_to @white_list_word, notice: 'White list word was successfully created.' }
        format.json { render :show, status: :created, location: @white_list_word }
      else
        format.html { render :new }
        format.json { render json: @white_list_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /white_list_words/1
  # PATCH/PUT /white_list_words/1.json
  def update
    respond_to do |format|
      if @white_list_word.update(white_list_word_params)
        format.html { redirect_to @white_list_word, notice: 'White list word was successfully updated.' }
        format.json { render :show, status: :ok, location: @white_list_word }
      else
        format.html { render :edit }
        format.json { render json: @white_list_word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /white_list_words/1
  # DELETE /white_list_words/1.json
  def destroy
    @white_list_word.destroy
    respond_to do |format|
      format.html { redirect_to white_list_words_url, notice: 'White list word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_white_list_word
      @white_list_word = WhiteListWord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def white_list_word_params
      params.fetch(:white_list_word, {})
    end
end
