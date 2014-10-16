require 'fog'

class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create

    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save

        @client = Fog::Storage.new(
          :provider => 'rackspace',
          :rackspace_username => ENV['RACKSPACE_USERNAME'],
          :rackspace_api_key => ENV['RACKSPACE_API_KEY'],
          :rackspace_region => :dfw
        )

        directory = @client.directories.get('CFEED_USER_IMG')
        file = directory.files.create(
          :key => "#{@image.id}.jpg",
          :body => params[:image][:upload]
        )
        @image.uri = file.public_url

        format.all { render text: "#{@image.id},#{@image.uri}" }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:uri)
    end
end
