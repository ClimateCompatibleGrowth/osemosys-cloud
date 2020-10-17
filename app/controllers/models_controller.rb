class ModelsController < ApplicationController
  def new
    @model = Model.new
  end

  def index
    @models = current_user.models.order(id: :desc).page(params[:page])
  end

  def show
    @model = current_user.models.find_by(id: params[:id])
    @versions = @model.versions.order(id: :desc)
  end

  def create
    @model = current_user.models.create(model_params)

    if @model.valid?
      flash.notice = 'Model created'
      redirect_to models_path
    else
      flash.now.alert = @model.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def model_params
    params.require(:model).permit(:name)
  end
end
