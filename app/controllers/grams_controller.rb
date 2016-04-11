class GramsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @grams = Gram.all
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

    render_unsuccessful(:not_found) if @gram.nil?
  end

  def edit
    @gram = Gram.find_by_id(params[:id])

    return render_unsuccessful(:not_found) if @gram.nil?

    return render_unsuccessful(:forbidden) if @gram.user != current_user
  end

  def update
    @gram = Gram.find_by_id(params[:id])

    return render_unsuccessful(:not_found) if @gram.nil?

    return render_unsuccessful(:forbidden) if @gram.user != current_user

    @gram.update_attributes(gram_params)

    if @gram.valid?      
      redirect_to root_path
    else
      return render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gram = Gram.find_by_id(params[:id])

    return render_unsuccessful(:not_found) if @gram.nil?

    return render_unsuccessful(:forbidden) if @gram.user != current_user

    @gram.destroy
    redirect_to root_path
  end

  private
  def gram_params
    params.require(:gram).permit(:message, :picture)
  end

  def render_unsuccessful(status=:not_found)
    render text: '#{status.to_s.titlize} :(', status: status
  end
end
