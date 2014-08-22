class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :set_college, only: [:index, :trending]

  # GET /api/v1/tags
  # GET /api/v1/tags.json
  def index
    if @college.nil?
      @tags = Tag.all
    else
      #@tags = 
    end
  end

  def trending
    @tags = Tag.top(@college, params[:per_page])
  end

  # GET /api/v1/tags/1
  # GET /api/v1/tags/1.json
  def show
  end

  # GET /api/v1/tags/new
  def new
    @tag = Tag.new
  end

  # GET /api/v1/tags/1/edit
  def edit
  end

  # POST /api/v1/tags
  # POST /api/v1/tags.json
  def create
    @tag = Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to @tag, notice: 'Tag was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tag }
      else
        format.html { render action: 'new' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/v1/tags/1
  # PATCH/PUT /api/v1/tags/1.json
  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to @tag, notice: 'Tag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/v1/tags/1
  # DELETE /api/v1/tags/1.json
  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def set_college
      if params[:college_id]
        @college = College.find(params[:college_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:tag).permit(:text, :post_id, :casedText)
    end
end
