class PostsController < ApplicationController
  #before_filter :authenticate_user!
  
  def index
    @posts = Post.find(:all, :include => :photos)
  end
  
  def new
    @post = Post.new
    #3.times { @post.photos.build }
  end
  
  # TODO: need to refactor this code; this will do for now
  def upload
    uploader = PreviewUploader.new
    uploader.store!(params[:preview])
    image = EXIFR::JPEG.new(uploader.path)
    
    if image.exif? && !image.gps_latitude.nil?
      lat = image.gps_latitude[0].to_f + (image.gps_latitude[1].to_f / 60) + (image.gps_latitude[2].to_f / 3600)
      long = image.gps_longitude[0].to_f + (image.gps_longitude[1].to_f / 60) + (image.gps_longitude[2].to_f / 3600) 
      long = long * -1 if image.gps_longitude_ref == "W"   # (W is -, E is +)
      lat = lat * -1 if image.gps_latitude_ref == "S"      # (N is +, S is -)
    end
    
    render :json => {
      :url => uploader.url,
      :preview => uploader.versions[:small].url,
      :latitude => lat,
      :longitude => long,
      :date_taken => image.date_time_original
    }
  end
  
  def create
    @post = current_user.posts.build(params[:post])
    photo = @post.photos.build(:user => current_user)
    photo.image.download!(request.env['HTTP_ORIGIN'] + params[:attachment])
    
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def show
  end
  
end
