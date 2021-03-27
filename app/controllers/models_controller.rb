class ModelsController < ApplicationController
  def new
    @model = Model.new
  end

  def index
    @models = current_user.models.kept.order(id: :desc).page(params[:page])
  end

  def show
    @model = current_user.models.kept.find_by(id: params[:id])
    if @model
      @versions = @model.versions.order(id: :desc)
    else
      redirect_to :not_found
    end
  end

  def create
    @model = current_user.models.kept.create(model_params)

    if @model.valid?
      flash.notice = t('flash.model.created')
      redirect_to model_path(@model)
    else
      flash.now.alert = @model.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @model = current_user.models.kept.find_by(id: params[:id])
    redirect_to :not_found and return unless @model
  end

  def update
    @model = current_user.models.kept.find_by(id: params[:id])
    redirect_to :not_found and return unless @model

    if @model.update(model_params)
      flash.notice = t('flash.model.updated')
      redirect_to model_path(@model)
    else
      flash.now.alert = @model.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @model = current_user.models.kept.find_by(id: params[:id])
    redirect_to :not_found and return unless @model

    if @model.discard
      flash.notice = t('flash.model.deleted')
      redirect_to models_path
    end
  end

  private

  def model_params
    params.require(:model).permit(:name)
  end
end
