class CommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])
    @comment = current_user.comments.build(params[:comment])

    @comments = @post.comments
    @comment.post = @post
    
    authorize! :create, @comment, message: "You need to be signed in to do that."
    if @comment.save
      redirect_to [@topic, @post], notice: "Comment was saved successfully."
    else
      flash[:error] = "There was an error saving your comment. Please try again."
      render 'posts/show'
    end
  end
end
