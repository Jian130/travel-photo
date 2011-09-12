class LikesController < ApplicationController
  def create
    @likeable = find_likeable
    @like = @likeable.likes.build(params[:like])
    
    if @like.save
      return request.url
    end
    # if @like.save
    #   render :json => @likeable.likes.count
    # end
    # if @like.save
    #   render :json => @likeaable.likes.count
    # else
    #   render :json
  end
  
  private
  
  def find_likeable
    params.each do |name, value|
      if name =~ /(.*)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
