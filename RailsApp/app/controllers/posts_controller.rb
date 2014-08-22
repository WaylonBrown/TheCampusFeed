class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  before_action :require_college, only: [:create]
  before_action :set_college, only: [:index, :create, :byTag, :recent, :trending]

  def many
    posts = []
    params[:many_ids].each{ |id|
      @cur = Post.find_by_id(id)
      if @cur && !@cur.hidden
        posts.push @cur
      end
    }
    render json: posts
  end

  def search
    posts = Post.search_by_text(params[:searchText]).order('created_at desc').page(params[:page]).per(params[:per_page])
    render json: posts
  end

  def searchCount
    render json: Post.search_by_text(params[:searchText]).count
  end

  def count
    render json: Post.all.count
  end

  def byTag
    @all_tags = Tag.where("lower(text) = ?", params[:tagText].downcase)

    @tag_ids = []
    @all_tags.each{ |tag|
      @tag_ids << tag.id
    }

    @posts_with_tags = Post.joins(:tags).where(tags: {id: @tag_ids})
    if @college
      @posts_with_tags = @posts_with_tags.where(posts: {college_id: @college.id})
    end

    if @posts_with_tags.any?
      render json: @posts_with_tags.order('created_at desc').page(params[:page]).per(params[:per_page])
    else
      render json: {:tag => ["does not exist."]}, status: 400
    end
  end

  def hidden
    if !@college.nil?
      @posts = @college.posts
    else
      @posts = Post.all
    end

    render json: @posts.where('hidden IS TRUE').page(params[:page]).per(params[:per_page])
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

    if params[:page]
      @posts = @posts.page(params[:page]).per(params[:per_page])
    end

    render json: @posts
  end

  def recent
    if !@college.nil?
      @posts = @college.posts
    else
      @posts = Post.all
    end
    
    render json: @posts.where('hidden IS NOT TRUE').order('created_at desc').page(params[:page]).per(params[:per_page])
  end

  def trending
    if !@college.nil?
      @posts = @college.posts
    else 
      @posts = Post.all
    end
    
    render json: @posts.where('hidden IS NOT TRUE').order('score desc').page(params[:page]).per(params[:per_page])
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

    params.require(:user_token)

    @post = @college.posts.build(post_params)

    respond_to do |format|
      if @post.save
        @post.votes.create({upvote: true})
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
      params.require(:post).permit(:text, :score, :lat, :lon, :college_id, :user_token)
    end
    def require_college
      params.require(:college_id)
    end
end
