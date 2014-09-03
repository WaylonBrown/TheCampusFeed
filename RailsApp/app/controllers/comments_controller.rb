class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_post, only: [:create, :index]

  def many
    comments = []
    params[:many_ids].each{ |id|
      @cur = Comment.find_by_id(id)
      if @cur && !@cur.hidden
        comments.push @cur
      end
    }
    render json: comments
  end

  def search
    comments = Comment.search_by_text(params[:searchText]).page(params[:page]).per(params[:per_page])
    render json: comments
  end

  def searchCount
    render json: Comment.search_by_text(params[:searchText]).count
  end

  def count
    render json: Comment.all.count
  end

  # GET /comments
  # GET /comments.json
  def index
    #Don't want to paginate in the app just yet, so auto-load all comments
    if params[:page]
      @comments = @post.comments.order('score desc, created_at desc').page(params[:page]).per(params[:per_page])
    else
      @comments = @post.comments.order('score desc, created_at desc')
    end
    render json: @comments
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = @post.comments.build(comment_params)
    @comment.vote_delta = 1

    respond_to do |format|
      if @comment.save
        @comment.votes.create({upvote: true})
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:text, :score, :post_id)
    end
end
