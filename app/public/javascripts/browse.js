$(function() {
  /**
   * Cache DOM
   */
  const recipes = recipeList; // recipeList is declared in browse.ejs
  const ingredients = ingredientList // declared in browse.ejs
  const cuisines = cuisineList;
  const categories = categoryList;
  const diets = dietList;

  const $recipeItem = $('.recipe-item');
  const $category = $('#recipe-category');
  const $cuisine = $('#recipe-cuisine');
  const $diet = $('#dietary-restriction');
  const $search = $('#search');
  const $clear = $('.form-control-clear');



  let searchList = buildSearchList();


function buildSearchList() {
  const searchList = [];

    recipes.forEach((recipe) => {
      searchList.push({
        id: recipe.recipe_id,
        name: recipe.recipe_name,
        is_recipe: true,
        typeName: 'Recipe',
        recipe_category_id: recipe.recipe_category_id,
        cuisines: recipe.cuisines,
        restrictedDiets: recipe.restrictedDiets,
      });
    });

    ingredients.forEach((ingredient) => {
      searchList.push({
        id: ingredient.ingredient_id,
        name: ingredient.ingredient_name,
        typeName: 'Ingredient',
        is_recipe: false,
      });
    });

    categories.forEach((category) => {
      searchList.push({
        id: category.recipe_category_id,
        name: category.recipe_category_name,
        typeName: 'Category',
        is_recipe: false,
      });
    });

    cuisines.forEach((cuisine) => {
      searchList.push({
        id: cuisine.cuisine_id,
        name: cuisine.cuisine_name,
        typeName: 'Cuisine',
        is_recipe: false,
      });
    });

    diets.forEach((diet) => {
      searchList.push({
        id: diet.dietary_restriction_id,
        name: diet.dietary_restriction_name,
        typeName: 'Diet',
        is_recipe: false,
      });
    });

  return searchList;
}


// setup the recipe item seach.
const recipeSearch = new Bloodhound({
    datumTokenizer: (data) => Bloodhound.tokenizers.whitespace(data.name),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    local: searchList,
    sorter: (a, b) => {
      const curr = $search.val();

      if (curr == a.name) {
        return -1;
      } else if (curr == b.name) {
        return 1;
      } else if (curr.toLowerCase() == a.name.toLowerCase()) {
        return -1;
      } else if (curr.toLowerCase() == b.name.toLowerCase()) {
        return 1;
      } else if (a.name < b.name) {
        return -1;
      } else if (a.name > b.name) {
        return 1;
      }
      return 0;
  },
});

// initialize the bloodhound suggestion engine
recipeSearch.initialize();


// instantiate the typeahead UI
$search.typeahead(null, {
  displayKey: 'name',
  name: 'search-items',
  source: recipeSearch.ttAdapter(),
  templates: {
    suggestion: (data) => {
      return `
        <div class="search-item">
          <div class="search-item-name">${data.name}</div>
          <div class="search-item-type search-item-${data.typeName.toLowerCase()}">${data.typeName}</div>
        </div>`;
    },
  },
});


// handle a search selection
$search.bind('typeahead:select', function(ev, item) {
  getSearchResults(item);
});

// if the user presses enter, treat it as a selection of the first suggestion
// $search.on('keyup', function(event) {
//   if (event.which == 13) {
//     event.preventDefault();
//     $('.tt-selectable').first().click();
//   }
// });


  /**
   * Event Handlers
   */
  $category.change(() => {
    updateRecipeDisplay();
  });

  $cuisine.change(() => {
    updateRecipeDisplay();
  });

  $diet.change(() => {
    updateRecipeDisplay();
  });


  // clear any of the filters
  $clear.click(function() {
    const $next = $(this).next();

    if ($next.is('.twitter-typeahead')) {
      $next.children('input').val('');
    } else {
      $next.prop('selectedIndex', 0);
    }

    updateRecipeDisplay();
  });





  /**
   * Functions -- Filters
   */

   // returns the recipes that pass through the category filter.
  function getCategoryFilter() {
    const val = sanitize($category.val());
    let matches = undefined;

    if (val) {
      matches = recipes.filter((recipe) => {
        return recipe.recipe_category_id === val;
      });
    }

    return matches || recipes;
  }


  // returns the recipes that pass through the cuisine filter.
  function getCuisineFilter() {
    const val = sanitize($cuisine.val());
    let matches;

    if (val) {
      matches = recipes.filter((recipe) => {
        return recipe.cuisines.some((cuisine) => {
          return cuisine.cuisine_id === val;
        });
      });
    }

    return matches || recipes;
  }


  // returns the recipes that pass through the diet filter.
  function getDietFilter() {
    const val = sanitize($diet.val());
    let matches;

    if (val) {
      matches = recipes.filter((recipe) => {
        return recipe.restrictedDiets.every((diet) => {
          return diet.dietary_restriction_id != val;
        });
      });
    }

    return matches || recipes;
  }


  // returns the recipe(s) that have a qualifying match with the search query.
  function getSearchResults(item) {
    // console.log(item);

    if (item.is_recipe) {
      // if it's a recipe, go directly to the recipe page.
      console.log('its a recipe');
      window.location.href = `/recipes/${item.id}`;
    } else {
      // otherwise, use the search content to filter the browsable results.
      console.log('not a recipe');
    }

  }



  // looks at each of the recipe filters and shows only the
  //   recipes which meet the criteria of all the filters.
  function updateRecipeDisplay() {
    // hide all the recipes by default.
    $recipeItem.hide();

    // then show only the recipes which pass through all filters.
    const filters = [
      getCategoryFilter(),
      getCuisineFilter(),
      getDietFilter(),
    ];

    const matches = recipes.filter((r) => {
      return filters.every((f) => {
        return f.some((el) => el.recipe_id === r.recipe_id);
      });
    });

    for (let i = 0; i < matches.length; i++) {
      $(`#recipe-${matches[i].recipe_id}`).show();
    }
  }


  // checks if a value is numeric.
  function isNumeric(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
  }

  // Converts a value to its actual data type.
  function sanitize(value) {
    if (value === 'null' || undefined) {
      return null;
    } else if (isNumeric(value)) {
      return parseInt(value);
    }
    return value;
  }

});
