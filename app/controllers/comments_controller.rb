class CommentsController < ApplicationController
  def index
    @commentable = find_commentable
    @comment = @commentable.coments
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
  end

  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params[:comment])
    
    if @comment.save
      redirect_to root_path
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment"
      redirect_to @comment
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully deleted comment"
    redirect_to comments_url
  end
  
  private
  
  def find_commentable
    params.each do |name, value|
      if name =~ /(.*)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end
