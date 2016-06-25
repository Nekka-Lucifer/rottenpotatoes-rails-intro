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
    @all_ratings = ['G','PG','PG-13','R']
    @sort = params[:sort] ? params[:sort] : session[:sort]
    @ticked_ratings = if params[:ratings]
                        params[:ratings].keys 
                      elsif session[:ratings]
                        session[:ratings]
                      else
                        @all_ratings
                      end
    params[:ratings] ||= {} 
    @movies = Movie.where(:rating => @ticked_ratings).order(sort_column)
    session[:sort] = @sort
    session[:ratings] = @ticked_ratings
    ratings_hash = @ticked_ratings.map{|i| [i,1]}.to_h
    if session[:sort] != params[:sort] or @ticked_ratings != params[:ratings].keys
      flash.keep
      redirect_to movies_path(sort: @sort, ratings: ratings_hash)
    end
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

  def sort_column
    Movie.column_names.include?(@sort) ? @sort : ""
  end
end
