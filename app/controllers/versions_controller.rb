class VersionsController < ApplicationController
  def new
    @version = Version.new(model_id: params[:model_id])
  end

  def show
    @version = current_user.versions.find_by(id: params[:id])
    if @version
      @runs = @version.runs.for_index_view(params[:page]).per(10)
    else
      redirect_to :not_found
    end
  end

  def create
    @version = current_user.versions.create(version_params)

    if @version.valid?
      flash.notice = t('flash.version.created')
      redirect_to version_path(@version)
    else
      flash.now.alert = @version.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def version_params
    params.require(:version).permit(:name, :model_id)
  end
end
