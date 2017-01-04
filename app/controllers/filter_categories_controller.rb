class FilterCategoriesController < ApplicationController
  before_action :set_filter_category, only: [:show, :edit, :update, :destroy]

  # GET /filter_categories
  # GET /filter_categories.json
  def index
    @filter_categories = FilterCategory.all
  end

  # GET /filter_categories/1
  # GET /filter_categories/1.json
  def show
  end

  # GET /filter_categories/new
  def new
    @filter_category = FilterCategory.new
  end

  # GET /filter_categories/1/edit
  def edit
  end

  # POST /filter_categories
  # POST /filter_categories.json
  def create
    @filter_category = FilterCategory.new(filter_category_params)

    respond_to do |format|
      if @filter_category.save
        format.html { redirect_to @filter_category, notice: 'Filter category was successfully created.' }
        format.json { render :show, status: :created, location: @filter_category }
      else
        format.html { render :new }
        format.json { render json: @filter_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filter_categories/1
  # PATCH/PUT /filter_categories/1.json
  def update
    respond_to do |format|
      if @filter_category.update(filter_category_params)
        format.html { redirect_to @filter_category, notice: 'Filter category was successfully updated.' }
        format.json { render :show, status: :ok, location: @filter_category }
      else
        format.html { render :edit }
        format.json { render json: @filter_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filter_categories/1
  # DELETE /filter_categories/1.json
  def destroy
    @filter_category.destroy
    respond_to do |format|
      format.html { redirect_to filter_categories_url, notice: 'Filter category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filter_category
      @filter_category = FilterCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def filter_category_params
      params.require(:filter_category).permit(:category_id, :category_id, :filterset_id, :filterset_id)
    end
end
