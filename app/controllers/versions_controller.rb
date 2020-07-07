class VersionsController < ApplicationController
  def new
    @version = Version.new
  end

  def index
    @versions = current_user.versions.order(id: :desc).page(params[:page])
  end

  def show
    @version = current_user.versions.find_by(id: params[:id])
    @runs = @version.runs
  end

  def create
    @version = current_user.versions.create(version_params)

    if @version.valid?
      flash.notice = 'Run version created'
      redirect_to versions_path
    else
      flash.now.alert = @version.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def version_params
    params.require(:version).permit(:name)
  end
end
