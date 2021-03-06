class TwitterProfilesController < ApplicationController

  respond_to :html

  helper_method :resource
  helper_method :watson_personalities

  def create
    service = FetchTwitterProfile.new(params_resources[:username], resource)
    service.perfom!

    unless service.success?
      flash[:notice] = resource.errors.full_messages.to_sentence
      redirect_to root_path
    else
      respond_with resource, location: twitter_profile_path(service.twitter_profile.id)
    end
  end

  private

  def resource
    @resource ||=
      case action_name
      when 'new', 'create'
        TwitterProfile.new
      when 'show'
        TwitterProfile.find(params[:id])
      end
  end

  def watson_personalities
    @watson_personalities ||= resource.try(:watson_personalities).only_dominants.order_desc.limit(3)
  end

  def params_resources
    params.require(:resource).permit(:username)
  end

end
