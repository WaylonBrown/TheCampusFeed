class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :require_college, only: [:create]
  before_action :set_college, only: [:index, :create, :byTag, :recent, :trending]

  def search
    posts = Post.search_by_text(params[:searchText])
    paginate json: posts
  end

  def searchCount
    render json: Post.search_by_text(params[:searchText]).count
  end

  def count
    render json: Post.all.count
  end

  def byTag
    @tag = Tag.find_by(text: params[:tagText])

    if @tag
      #Paginate by 25
      if @college
        paginate json: @tag.posts.select{ |p| p.college_id == @college.id }
      else
        paginate json: @tag.posts
      end
    else
      render json: {:tag => ["does not exist."]}, status: 400
    end
  end

  # GET /posts
  # GET /posts.json
  # GET /colleges/1/posts
  def index
    if !@college.nil?
      @posts = @college.posts
    else 
      @posts = Post.all
    end
    
    paginate json: @posts
  end

  def recent
    if !@college.nil?
      @posts = Post.where('college_id = '+@college.id.to_s).order('created_at desc')
    else 
      @posts = Post.order('created_at desc')
    end
    
    paginate json: @posts
  end

  def trending
    if !@college.nil?
      @posts = Post.where('college_id = '+@college.id.to_s).order('score desc')
    else 
      @posts = Post.order('created_at desc')
    end
    
    paginate json: @posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create

    @post = @college.posts.build(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_college 
      if params[:college_id]
        @college = College.find(params[:college_id])
      end
    end
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:text, :score, :lat, :lon, :college_id)
    end
    def require_college
      params.require(:college_id)
    end
end
