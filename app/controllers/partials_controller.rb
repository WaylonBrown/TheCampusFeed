class PartialsController < ApplicationController
  before_action :set_partial, only: [:show, :edit, :update, :destroy]

  def byName
    render partial: params[:partialName]
  end

  # GET /partials
  # GET /partials.json
  def index
    @partials = Partial.all
  end

  # GET /partials/1
  # GET /partials/1.json
  def show
  end

  # GET /partials/new
  def new
    @partial = Partial.new
  end

  # GET /partials/1/edit
  def edit
  end

  # POST /partials
  # POST /partials.json
  def create
    @partial = Partial.new(partial_params)

    respond_to do |format|
      if @partial.save
        format.html { redirect_to @partial, notice: 'Partial was successfully created.' }
        format.json { render action: 'show', status: :created, location: @partial }
      else
        format.html { render action: 'new' }
        format.json { render json: @partial.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partials/1
  # PATCH/PUT /partials/1.json
  def update
    respond_to do |format|
      if @partial.update(partial_params)
        format.html { redirect_to @partial, notice: 'Partial was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @partial.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partials/1
  # DELETE /partials/1.json
  def destroy
    @partial.destroy
    respond_to do |format|
      format.html { redirect_to partials_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partial
      @partial = Partial.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def partial_params
      params.require(:partial).permit(:name)
    end
end
