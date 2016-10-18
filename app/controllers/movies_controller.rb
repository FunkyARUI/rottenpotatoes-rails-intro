class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
          @sortby = params[:sortby]||session[:sortby]
          if @sortby
           @movies=Movie.order(@sortby)
         end
    @all_ratings= Movie.collectrating
    @ratingshash=params[:ratings]||session[:ratings]||{}
    

    
    if params[:sortby]!=session[:sortby]
      session[:sortby]=@sortby
      redirect_to movies_path(:sortby=>@sortby, :ratings=>@ratingshash) and return
    end    
    
    if params[:ratings] !=session[:ratings] and params[:ratings]!={}
      session[:ratings]=@ratingshash
      redirect_to movies_path(:sortby=>@sortby, :ratings=>@ratingshash) and return 
   end
      @ratings=@ratingshash.keys
    @movies=@movies.where(rating:@ratings)
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
