class BlogpostsController < ApplicationController
  def index
    @blogposts = Blogpost.published
  end

  def show
    @blogpost = Blogpost.find params[:id]
  end
end
