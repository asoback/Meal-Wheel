const express = require('express');
const router = express.Router();

const Recipes = require('../controllers/Recipe');


/* GET recipe admin page. */
router.get('/', (req, res, next) => {
  Recipes.getAll((err, recipes) => {
    res.render('recipe', {
      page: 'Recipes',
      menuId: 'recipes',
      data: recipes,
      session: req.session,
    });
  });
});


/* GET an individual recipe page. */
router.get('/:id', (req, res, next) => {
  Recipes.getById(req.params.id, (err, recipe) => {
    res.render('singleRecipe', {
      page: recipe.recipe_name,
      menuId: 'recipe',
      recipe: recipe[0],
    });
  });
});


module.exports = router;
