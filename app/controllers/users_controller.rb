class UsersController < ApplicationController
    

    # POST /users
    def create
        @user = User.create!(user_params)
        session[:user_id] = @user.id
        render json: @user, status: :created
    rescue ActiveRecord::RecordInvalid => invalid
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end

    def show
        return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
        @user = User.find_by(id: session[:user_id])
        render json: @user, status: :created
    end


    private
    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end
end
