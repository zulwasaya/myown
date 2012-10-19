class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id)# look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  

    @all_ratings=Movie.allratings



    @checked_ratings = (params["ratings"].present? ? params["ratings"] : @all_ratings)


    @sortby= params[:sort] # retrieve sort order from URI route
    logger.debug 'params[:rating]'
    logger.debug params[:rating]
    if (@sortby=='title')

        @movies = Movie.order("title").where("rating IN (?)",params[:rating])
        @titleHighlight = 'hilite'
        @release_dateHighlight = ''

      elsif (@sortby=='release_date')

        @movies = Movie.order("release_date").where("rating IN (?)",params[:rating])
        @titleHighlight = ''
        @release_dateHighlight = 'hilite'

      elsif (params["commit"]== 'Refresh')


        @movies= Movie.where("rating IN (?)",@checked_ratings)
        # Save current value of @checked_ratings for use in title and release date column sort
        @checked_ratings = @checked_ratings

      else


        @movies = Movie.all
        @titleHighlight = ''
        @release_dateHighlight = ''

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
