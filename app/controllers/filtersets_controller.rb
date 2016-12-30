class FiltersetsController < ApplicationController
  before_action :set_filterset, only: [:show, :edit, :update, :destroy]

  # GET /filtersets
  # GET /filtersets.json
  def index
    @filtersets = Filterset.all
  end

  # GET /filtersets/1
  # GET /filtersets/1.json
  def show
  end

  # GET /filtersets/new
  def new
    @filterset = Filterset.new
  end

  # GET /filtersets/1/edit
  def edit
  end

  # POST /filtersets
  # POST /filtersets.json
  def create
    @filterset = Filterset.new(filterset_params)

    respond_to do |format|
      if @filterset.save
        format.html { redirect_to @filterset, notice: 'Filterset was successfully created.' }
        format.json { render :show, status: :created, location: @filterset }
      else
        format.html { render :new }
        format.json { render json: @filterset.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filtersets/1
  # PATCH/PUT /filtersets/1.json
  def update
    respond_to do |format|
      if @filterset.update(filterset_params)
        format.html { redirect_to @filterset, notice: 'Filterset was successfully updated.' }
        format.json { render :show, status: :ok, location: @filterset }
      else
        format.html { render :edit }
        format.json { render json: @filterset.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filtersets/1
  # DELETE /filtersets/1.json
  def destroy
    @filterset.destroy
    respond_to do |format|
      format.html { redirect_to filtersets_url, notice: 'Filterset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filterset
      @filterset = Filterset.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def filterset_params
      params.fetch(:filterset, {})
    end
end
