class VersionsController < ApplicationController
  def new
    @version = Version.new(model_id: params[:model_id])
  end

  def index
    @versions = current_user.versions.order(id: :desc).page(params[:page])
  end

  def show
    @version = current_user.versions.find_by(id: params[:id])
    @runs = @version.runs.for_index_view(params[:page])
  end

  def create
    @version = current_user.versions.create(version_params)

    if @version.valid?
      flash.notice = 'Run version created'
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
