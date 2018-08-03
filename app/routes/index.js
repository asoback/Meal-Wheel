const express = require('express');
const router = express.Router();
const helpers = require('../helpers');

const Categories = require('../controllers/RecipeCategory');
const Cuisines = require('../controllers/Cuisine');
const Diets = require('../controllers/DietaryRestriction');
const Recipes = require('../controllers/Recipe');
const Users = require('../controllers/User');


/* GET home page. */
router.get('/', (req, res, next) => {
  Categories.getAll((err, categories) => {
    Cuisines.getAll((err, cuisines) => {
      Diets.getAll((err, diets) => {
        res.render('index', {
          page: 'Home',
          menuId: 'home',
          session: req.session,
          cuisines: cuisines,
          categories: categories,
          diets: diets,
        });
      });
    });
  });
});



/*
Spin wheel to get a single recipe based on filters.
See spinButton event listener function in public/javascripts/home.js
*/
router.post('/', (req, res, next) => {
  const context = {
    category: req.body.category,
    cuisine: req.body.cuisine,
    diet: req.body.diet,
    user: 0,
  };

  // if user exists, it will be passed to the filter
  //  function to exclude any 'disliked' recipes.
  if (req.session.user) {
    context.user = req.session.user.user_id;
  }


  Users.getById(context.user, (err, user) => {
    // moved the HTML to the server so we can check for session.
    Recipes.getByFilter(context, (err, recipe) => {
      const result = recipe[0];
      let renderHTML;

      if (!result) {
        renderHTML = `
        <div class="row align-items-center justify-content-center text-center">
          <div class="col-sm-8 col-md-6 col-lg-4">
            <div class="card mb-5" id="${result.recipe_id}">
              <div class="card-body">
                <h5 class="card-title">No Matching Recipe</h5>
                <p class="card-text">Try chaging some parameters and spin again!</p>
              </div>
            </div>
          </div>
        </div>`;
      } else {
        const placeholder = '/images/recipe-placeholder.png';
        const image = (result.recipe_image_url == null) ? placeholder : result.recipe_image_url;

        renderHTML = `
        <div class="row align-items-center justify-content-center text-center">
          <div class="col-sm-8 col-md-6 col-lg-4">
            <div class="card mb-5" id="${result.recipe_id}">
              <a href="/recipes/${result.recipe_id}">
                <img class="card-img-top" src="${image}">
              </a>
              <div class="card-body">
                <h5 class="card-title">${result.recipe_name}</h5>
                  <p class="card-text">${result.recipe_description}</p>`;


        if (user[0]) {
          // determine the user's liked & disliked recipes
          context.likedRecipes = helpers.mapObjectKey((user[0].likedRecipes), 'recipe_id') || context.likedRecipes;
          context.dislikedRecipes = helpers.mapObjectKey((user[0].dislikedRecipes), 'recipe_id') || context.dislikedRecipes;

          // set the classes of the thumbs-up/down icons to reflect whether liked or disliked.
          const likedClass = (context.likedRecipes.includes(result.recipe_id) ? 'selected' : '');
          const dislikedClass = (context.dislikedRecipes.includes(result.recipe_id) ? 'selected' : '');

          renderHTML +=
            `<span class="card-thumbs text-right">
              <i class="far fa-thumbs-up recipe-like ${likedClass}" id="recipe-<%= recipes[i].recipe_id %>-like"></i>
              <i class="far fa-thumbs-down recipe-dislike ${dislikedClass}" id="recipe-<%= recipes[i].recipe_id %>-dislike"></i>
            </span>`;
        }

        renderHTML +=
          `</div>
            </div>
          </div>
        </div>`;
      }

      res.send({ recipe: renderHTML });
    });
  });



});



// logs the user out and redirects to the home page.
router.get('/logout', (req, res, next) => {
  req.session.destroy();
  res.redirect('/');
});



// helper function to map the liked/disliked recipe object to an array.
function mapSignificantRecipes(jsonArr) {
  return jsonArr.map((obj) => {
    return obj.recipe_id;
  });
}


module.exports = router;
