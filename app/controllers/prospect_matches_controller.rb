class ProspectMatchesController < ApplicationController
  def index
    redirect_to root_path unless current_user
    @page_title = "Home Alerts"
    @prospect_matches = current_user.prospect_matches
  end

  def new
    redirect_to root_path unless current_user
    params[:property_types] = ""
    @prospect_match = current_user.prospect_matches.new
  end

  def create
    redirect_to root_path unless current_user
    @prospect_match = current_user.prospect_matches.new(prospect_match_params)
    params[:property_types] ||= []
    @prospect_match.property_types = params[:property_types].join(",")
    @prospect_match.city = params[:locality]
    if @prospect_match.save
      redirect_to prospect_matches_path, notice: "You have successfully subscribed for regular updates."
    else
      render "new"
    end
  end

  def edit
    redirect_to root_path unless current_user
    @prospect_match = current_user.prospect_matches.where(id: params[:id]).first
    redirect_to root_path unless @prospect_match
    params[:city] = @prospect_match.city
    params[:locality] = @prospect_match.city
    params[:property_types] = @prospect_match.property_types || ""
  end

  def update
    redirect_to root_path unless current_user
    @prospect_match = current_user.prospect_matches.where(id: params[:id]).first
    redirect_to root_path unless @prospect_match
    @prospect_match.assign_attributes(prospect_match_params)
    params[:property_types] ||= []
    @prospect_match.property_types = params[:property_types].join(",")
    @prospect_match.city = params[:locality]
    if @prospect_match.save
      redirect_to prospect_matches_path, notice: "You have successfully changed your settings."
    else
      render "edit"
    end
  end

  def destroy
    redirect_to root_path unless current_user
    @prospect_match = current_user.prospect_matches.where(id: params[:id]).first
    redirect_to root_path unless @prospect_match
    @prospect_match.destroy
    redirect_to prospect_matches_path
  end

  private

  def prospect_match_params
    params.require(:prospect_match).permit!
  end
end
