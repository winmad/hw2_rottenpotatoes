class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false

    #debugger

    if params[:sort] == nil
      if session[:sort] == nil
        session[:sort] = :no_sort
      end
      redirect = true
    else
      session[:sort] = params[:sort]
    end
    sort = session[:sort]

    @all_ratings = Movie.all_ratings
    if params[:ratings] == nil
      #ratings_to_show = @all_ratings
      if session[:ratings] == nil
        session[:ratings] = Hash[@all_ratings.map{|r| [r, 1]}]
      end
      redirect = true
    else
      session[:ratings] = params[:ratings]
    end
    ratings_to_show = session[:ratings].keys
    @ratings_checker = Movie.ratings_checker(ratings_to_show)

    if redirect == true
      flash.keep
      redirect_to movies_path({ :sort => session[:sort], :ratings => session[:ratings] })
    end

    if (sort == ["no_sort"]) || (sort == [:no_sort]) ||
        (sort == "no_sort") || (sort == :no_sort)
      sort = []
    end

    @movies = Movie.order(sort).find(:all, :conditions => {:rating => ratings_to_show})
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
