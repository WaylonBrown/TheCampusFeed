include CollegesHelper

class CollegesController < ApplicationController
  before_action :set_college, only: [:show, :edit, :update, :destroy, :within, :image]

  def search
    colleges = College.search_by_text(params[:searchText])
    paginate json: colleges 
  end

  def searchCount
    render json: College.search_by_text(params[:searchText]).count
  end

  def count
    render json: College.all.count
  end

  def image
    suckr = ImageSuckr::GoogleSuckr.new
    render json: suckr.get_image_url({"q" => @college.name + " logo", "as_filetype" => 'png'})
  end

  # GET /colleges
  # GET /colleges.json
  def index
    @colleges = College.all
    paginate json: @colleges
  end

  # GET /colleges/1
  # GET /colleges/1.json
  def show
  end

  # GET /colleges/new
  def new
    @college = College.new
  end

  # GET /colleges/1/edit
  def edit
  end

  @@threshold = 24.14  #within 15 miles, roughly
  # GET /colleges/1/within
  def within
    render json: distance(Float(params[:lat]), Float(params[:lon]),
                          @college.lat, @college.lon) < @@threshold
  end

  def listNearby
    @ret = Array.new
    College.all.each do |c|
      if distance(Float(params[:lat]), Float(params[:lon]),
                  c.lat, c.lon) < @@threshold
        @ret.push(c)
      end
    end
    render json: @ret
  end

  # POST /colleges
  # POST /colleges.json
  def create
    @college = College.new(college_params)

    respond_to do |format|
      if @college.save
        format.html { redirect_to @college, notice: 'College was successfully created.' }
        format.json { render action: 'show', status: :created, location: @college }
      else
        format.html { render action: 'new' }
        format.json { render json: @college.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /colleges/1
  # PATCH/PUT /colleges/1.json
  def update
    respond_to do |format|
      if @college.update(college_params)
        format.html { redirect_to @college, notice: 'College was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @college.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /colleges/1
  # DELETE /colleges/1.json
  def destroy
    @college.destroy
    respond_to do |format|
      format.html { redirect_to colleges_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_college
      @college = College.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def college_params
      params.require(:college).permit(:name, :state, :lat, :lon)
    end
end
