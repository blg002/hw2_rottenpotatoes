class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @list_of_ratings = Movie.ratings

    @ratings_filter = session[:ratings] || {}
    @sort = params[:sort] || session[:sort]

    if params[:ratings]
      @ratings_filter = session[:ratings] = params[:ratings]
    end

    if @sort
      @movies = Movie.find_all_by_rating(@ratings_filter.keys, order: @sort)
      session[:sort] = @sort
    else
      @movies = Movie.find_all_by_rating(@ratings_filter.keys)
    end

    if ((!params.has_key?(:sort) && !params.has_key?(:ratings)) && (session.has_key?(:sort) || session.has_key?(:ratings)))
      redirect_to movies_path sort: session[:sort], ratings: session[:ratings]
    elsif !params.has_key?(:sort) && session.has_key?(:sort)
      redirect_to movies_path sort: session[:sort], ratings: params[:ratings]
    elsif !params.has_key?(:ratings) && session.has_key?(:ratings)
      redirect_to movies_path sort: params[:sort], ratings: session[:ratings]
    end

    # if ((!params.has_key?(:sort) || !params.has_key?(:ratings)) && (session.has_key?(:sort) || session.has_key?(:ratings)))
    #   flash.keep
    #   redirect_to movies_path sort: session[:sort], ratings: session[:ratings]
    # end
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
