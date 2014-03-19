class CommentsController < ApplicationController
  respond_to :html, :js

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = current_user.comments.build(params[:comment])

    @comments = @post.comments #sets up comments for render on failed validation
    @comment.post = @post #assigns the post to the comment being created
    
    authorize! :create, @comment, message: "You need to be signed in to do that."
    if @comment.save
      redirect_to [@topic, @post], notice: "Comment was saved successfully."
    else
      flash[:error] = "There was an error saving your comment. Please try again."
      render 'posts/show' #On failed validation or error, render this view
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    @comment = @post.comments.find(params[:id])

    authorize! :destroy, @comment, message: "You need to own the comment to delete it."
    if @comment.destroy
      flash[:notice] = "Comment was removed."
    else
      flash[:error] = "There was an error deleting the comment. Try again."
    end

    respond_with(@comment) do |f|
      f.html { redirect_to [@topic, @post] }
    end
  end
end
