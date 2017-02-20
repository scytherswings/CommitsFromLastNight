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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filterset
      @filterset = Filterset.find(params[:id])
    end
end
