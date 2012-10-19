class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id)# look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
   
    # Session code
    if params[:commit] == 'Refresh'
      session[:ratings] = params[:ratings]
    elsif session[:ratings] != params[:ratings]
      redirect = true
      params[:ratings] = session[:ratings]
    end

    if params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      redirect = true
      params[:sort] = session[:sort]
    end
    @ratings, @sortby = session[:ratings], session[:sort]
    if redirect
      redirect_to movies_path({:sort=>@sortby, :ratings=>@ratings})
    elsif
      sortkey = {'title'=>'title', 'release_date'=>'release_date'}
      if sortkey.has_key?(@sortby)
        sortbykey = Movie.order(sortkey[@sortby])
      else
        @sortby = nil
        query = Movie
      end
      @movies = @ratings.nil? ? sortbykey.all : sortbykey.find_all_by_rating(@ratings.map { |r| r[0] })
      @all_ratings=Movie.allratings
    end

  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
