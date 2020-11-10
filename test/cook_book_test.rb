require 'minitest/autorun'
require 'minitest/pride'
require './lib/pantry'
require './lib/ingredient'
require './lib/recipe'
require './lib/cook_book'
require 'date'
require 'mocha/minitest'

class CookBookTest < Minitest::Test

  def setup
    @ingredient1 = Ingredient.new({name: "Cheese", unit: "C", calories: 100})
    @ingredient2 = Ingredient.new({name: "Macaroni", unit: "oz", calories: 30})
    @ingredient3 = Ingredient.new({name: "Ground Beef", unit: "oz", calories: 100})
    @ingredient4 = Ingredient.new({name: "Bun", unit: "g", calories: 1})
    @recipe1 = Recipe.new("Mac and Cheese")
    @recipe2 = Recipe.new("Burger")
    @pantry = Pantry.new
  end

  def test_it_exists_and_has_attributes
    assert_instance_of CookBook, @cookbook
    #you dont need to use mocks to use stubs. you use parse to create the object. The object needs to be created after the stubs otherwise it wont work
    Date.stubs(:today).returns(Date.parse("20201105"))
    cookbook = CookBook.new
    assert_equal "11-02-2020", @cookbook.date
  end

  def test_it_can_add_recipes
    cookbook = CookBook.new

    assert_equal [], @cookbook.recipes
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    assert_equal [@recipe1, @recipe2], @cookbook.recipes
  end

  def test_it_can_return_ingredients
    cookbook = CookBook.new

    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe2.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 1)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    assert_equal ["Cheese", "Macaroni", "Ground Beef", "Bun"], @cookbook.ingredients
  end

  def test_highest_calorie_meal
    cookbook = CookBook.new

    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe2.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 1)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    assert_equal @recipe2, @cookbook.highest_calorie_meal
  end

  def test_recipe_name
    cookbook = CookBook.new

    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 100)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    assert_equal "Mac and Cheese", @cookbook.recipe_name(@recipe1)
  end

  def test_ingredient_hash
    cookbook = CookBook.new

    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 100)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    expected = {:ingredient=>"Bun", :amount=>"100 g"}
    assert_equal expected, @cookbook.ingredient_hash(@ingredient4)
  end

  def test_ingredients_hash
    cookbook = CookBook.new

    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient1, 4)
    @recipe2.add_ingredient(@ingredient4, 100)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    expected = [{:ingredient=>"Macaroni", :amount=>"8 oz"}, {:ingredient=>"Cheese", :amount=>"2 C"}]
    assert_equal expected, @cookbook.ingredients_hash(@recipe1)
  end


  def test_summary
    skip
    cookbook = CookBook.new

    @recipe1.add_ingredient(@ingredient2, 8)
    @recipe1.add_ingredient(@ingredient1, 2)
    @recipe2.add_ingredient(@ingredient3, 4)
    @recipe2.add_ingredient(@ingredient4, 100)
    @cookbook.add_recipe(@recipe1)
    @cookbook.add_recipe(@recipe2)
    expected = [{:name=>"Mac and Cheese",
                :details=>{:ingredients=>[{:ingredient=>"Macaroni", :amount=>"8 oz"}, {:ingredient=>"Cheese", :amount=>"2 C"}],
                          :total_calories=>440}},
                {:name=>"Burger",
                :details=>{:ingredients=>[{:ingredient=>"Ground Beef", :amount=>"4 oz"}, {:ingredient=>"Bun", :amount=>"100 g"}],
                            :total_calories=>500}}]
    assert_equal expected, @cookbook.summary
  end
end
