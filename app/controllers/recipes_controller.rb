class RecipesController < ApplicationController

    before_action :authorize

    # GET /recipes
    def index
        @recipes = Recipe.all 
        render json: @recipes
    end

    # POST /recipes
    def create
        new_recipe = @user.recipes.create!(recipe_params)
        render json: new_recipe, status: :created
    rescue ActiveRecord::RecordInvalid => exception
        render json: { errors: exception.record.errors.full_messages}, status: :unprocessable_entity
    end

    private
    def authorize
        @user = User.find_by(id: session[:user_id])
        render json: { errors: ["Not authorized"] }, status: :unauthorized unless @user
    end

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end
end
