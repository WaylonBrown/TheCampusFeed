class FlagsController < ApplicationController
  before_action :set_flag, only: [:show, :edit, :update, :destroy]
  before_action :set_flaggable, only: [:create]

  # GET /flags
  # GET /flags.json
  def index
    @flags = Flag.all
  end

  # GET /flags/1
  # GET /flags/1.json
  def show
  end

  # GET /flags/new
  def new
    @flag = Flag.new
  end

  # GET /flags/1/edit
  def edit
  end

  def should_hide? flaggable
    flaggable.flags.length > 5
  end

  def hide! flaggable
    flaggable.hidden = true
    flaggable.save
  end

  # POST /flags
  # POST /flags.json
  def create
    @flag = @flaggable.flags.create()
    if should_hide? @flaggable
      hide! @flaggable
    end

    respond_to do |format|
      if @flag.save
        format.html { redirect_to @flag, notice: 'Flag was successfully created.' }
        format.json { render action: 'show', status: :created, location: @flag }
      else
        format.html { render action: 'new' }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /flags/1
  # PATCH/PUT /flags/1.json
  def update
    respond_to do |format|
      if @flag.update(flag_params)
        format.html { redirect_to @flag, notice: 'Flag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @flag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /flags/1
  # DELETE /flags/1.json
  def destroy
    @flag.destroy
    respond_to do |format|
      format.html { redirect_to flags_url }
      format.json { head :no_content }
    end
  end

  private

    def set_flaggable
      if params[:comment_id]
        @flaggable = Comment.find(params[:comment_id])
      elsif params[:post_id]
        @flaggable = Post.find(params[:post_id])
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_flag
      @flag = Flag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def flag_params
      params.require(:flag)
    end
end
