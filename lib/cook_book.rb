
class CookBook
  attr_reader :recipes, :ingredients, :date

  def initialize
    @recipes = []
    @ingredients = []
    @date = Date.today.strftime('%m-%d-%Y')
  end

  def add_recipe(recipe)
    @recipes << recipe
    add_ingredient
  end

  def add_ingredient
    # better yet flat_map +map return ingredient name, uniq in the end, no need for conditional
    @recipes.map do |recipe|
    recipe.ingredients.each do |ingredient|
      if !@ingredients.include?(ingredient.name)
        @ingredients << ingredient.name
        end
      end
    end
  end

  def highest_calorie_meal
    @recipes.max_by do |recipe|
      recipe.total_calories
    end
  end

  def recipe_name(recipe)
      recipe.name
  end

  def ingredient_hash(ingredient_provided)
    ingredient_hash = {}
      @recipes.each do |recipe|
      recipe.ingredients_required.each_pair do |ingredient, quantity|
        if ingredient_provided == ingredient
        ingredient_hash[:ingredient] = ingredient.name
        ingredient_hash[:amount] = "#{quantity} #{ingredient.unit}"
        end
      end
    end
    ingredient_hash
  end

  def ingredients_hash(recipe)
    ingredients_hash = {}
      recipe.ingredients_required.each do |ingredient|
      ingredients_hash[:ingredients] = ingredient_hash(ingredient)
      ingredients_hash[:total_calories] = recipe.total_calories
    end
    ingredients_hash
  end

  def summary
    summary = []
    summary_details = {}
    @recipes.each do |recipe|
      recipe.ingredients_required.keys.each do |ingredient|
    summary_details[:name] = recipe_name(recipe)
    summary_details[:details] = ingredients_hash(recipe)
    summary << summary_details
      end
    end
  end

end

#from Kat
  # def summary
  #   info = []
  #   @recipes.each do |recipe|
  #     recipe_summary = {
  #       name: recipe.name,
  #       details: {
  #         ingredients: [],
  #         total_calories: recipe.total_calories
  #       }
  #     }
  #     sorted_ingredients = recipe.ingredients.sort_by do |ingred|
  #       ingred.calories * recipe.ingredients_required[ingred]
  #     end.reverse
  #     sorted_ingredients.each do |ingred|
  #       ingred_details = {
  #         ingredient: ingred.name,
  #         amount: "#{recipe.ingredients_required[ingred]} #{ingred.unit}"
  #       }
  #       recipe_summary[:details][:ingredients] << ingred_details
  #     end
  #     info << recipe_summary
  #   end
  #   info
  # end
