class StaticPagesController < ApplicationController 
  
  def home
    @feature = Video.find_by_feature(true)
    @video = Video.new

    @radical_creativity = Category.find(2).averages.limit(20).order('average DESC')
    @production_quality = Category.find(1).averages.limit(20).order('average DESC')
    @radical_inclusivity = Category.find(4).averages.limit(20).order('average DESC')
    @communal_effort = Category.find(3).averages.limit(20).order('average DESC')
    @civic_responsibility = Category.find(5).averages.limit(20).order('average DESC')
    @immediacy = Category.find(6).averages.limit(20).order('average DESC')
    render :home
  end

  def about
  end

end