class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
  end
  
  def new
    @gram = Gram.new
  end

  def create
    @gram = current_user.grams.create(gram_params)

    if @gram.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @gram = Gram.find_by_id(params[:id])

    render_not_found if @gram.nil?
  end

  def edit
    @gram = Gram.find_by_id(params[:id])

    render_not_found if @gram.nil?
  end

  def update
    @gram = Gram.find_by_id(params[:id])

    return render_not_found if @gram.nil?

    @gram.update_attributes(gram_params)

    if @gram.valid?      
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gram = Gram.find_by_id(params[:id])

    return render_not_found if @gram.nil?

    @gram.destroy
    redirect_to root_path
  end

  private
  def gram_params
    params.require(:gram).permit(:message)
  end

  def render_not_found
    render text: 'Not Found :(', status: :not_found
  end
end
