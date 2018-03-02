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
    #@movies = Movie.all


@all_ratings = Movie.ratings

if (params[:ratings])
@selected = params[:ratings].keys
session[:ratings] = params[:ratings]
elsif (session[:ratings])
flag = 1
@selected = session[:ratings].keys
else
@selected = @all_ratings
end

if (params[:sort])
@sort_method = params[:sort]
session[:sort] = params[:sort]
elsif (session[:sort])
flag = 1
@sort_method = session[:sort]
else
@sort_method = nil
end

if params[:sort]=="title"
	@title_header="hilite"
   elsif params[:sort]=="release_date"
	@release_date_header="hilite"
end

if flag == 1
redirect_to movies_path(:ratings => session[:ratings], :sort => session[:sort])
end
@movies = Movie.where(:rating => @selected).order(@sort_method)
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