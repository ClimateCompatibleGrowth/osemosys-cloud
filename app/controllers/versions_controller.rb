class VersionsController < ApplicationController
  def new
    @version = Version.new(model_id: params[:model_id])
  end

  def show
    @version = current_user.versions.kept.find_by(id: params[:id])
    if @version
      @runs = @version.runs.kept.for_index_view(params[:page]).per(10)
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

  def edit
    @version = current_user.versions.kept.find_by(id: params[:id])
    redirect_to :not_found and return unless @version
  end

  def update
    @version = current_user.versions.kept.find_by(id: params[:id])
    redirect_to :not_found and return unless @version

    if @version.update(version_params)
      flash.notice = t('flash.version.updated')
      redirect_to model_path(@version.model)
    else
      flash.now.alert = @version.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @version = current_user.versions.kept.find_by(id: params[:id])
    redirect_to :not_found and return unless @version

    if @version.discard
      flash.notice = t('flash.version.deleted')
      redirect_to model_path(@version.model)
    end
  end

  private

  def version_params
    params.require(:version).permit(:name, :model_id)
  end
end
