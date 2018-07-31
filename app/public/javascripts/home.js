 /**
  * rotating wheel, click it to spin it
  */

 var looper;
 var degrees = 0;
 document.getElementById("wheelImg").addEventListener('click', function() {
   degrees = 0;
   rotateAnimation("wheelImg", 8, 0);
 });

 //help from http://www.developphp.com/video/JavaScript/Transform-Rotate-Image-Spin-Smooth-Animation-Tutorial
 function rotateAnimation(el, speed, count) {
   var elem = document.getElementById("wheelImg");
   if (navigator.userAgent.match("Chrome")) {
     elem.style.WebkitTransform = "rotate(" + degrees + "deg)";
   } else if (navigator.userAgent.match("Firefox")) {
     elem.style.MozTransform = "rotate(" + degrees + "deg)";
   } else if (navigator.userAgent.match("MSIE")) {
     elem.style.msTransform = "rotate(" + degrees + "deg)";
   } else if (navigator.userAgent.match("Opera")) {
     elem.style.OTransform = "rotate(" + degrees + "deg)";
   } else {
     elem.style.transform = "rotate(" + degrees + "deg)";
   }
   count++;
   if (degrees < 361) {
     looper = setTimeout('rotateAnimation(\'' + el + '\',' + speed + ', ' + count + ')', speed);
   }
   degrees++;
 }

 $(function() {
   /**
    * Cache DOM
    */

   const spinButton = document.querySelector('#spinWheel');
   const display = document.querySelector('#recipeDisplay');

   const category = document.querySelector('#category');
   const cuisine = document.querySelector('#cuisine');
   const diet = document.querySelector('#diet');

   /**
    * Random recipe button click event handler
    */

   spinButton.addEventListener('click', function(e) {
     degrees = 0;
     rotateAnimation('wheelImg', 8, 0);

     const req = new XMLHttpRequest();

     // See routes/index.js for POST code
     req.open('POST', '/', true);
     req.setRequestHeader('Content-Type', 'application/json');
     req.addEventListener('load', function() {
       if (req.status >= 200 && req.status < 400) {
         if (!req.responseText == '') {
           const res = JSON.parse(req.responseText);
           displayRecipe(res.recipe);
         }
       }
     });

     const context = {
       category: sanitize(category.value),
       cuisine: sanitize(cuisine.value),
       diet: sanitize(diet.value),
     };

     req.send(JSON.stringify(context));
     e.preventDefault();
     e.stopPropagation();
   });



   /**
    * Functions
    */

   function isNumeric(n) {
     return !isNaN(parseFloat(n)) && isFinite(n);
   }


   // Converts a value to its appropriate value type.
   function sanitize(value) {
     if (value === 'null' || undefined) {
       return null;
     } else if (isNumeric(value)) {
       return parseInt(value);
     }
     return value;
   }


   // Renders the recipe in the html (or indicates no recipe was matched)
   function displayRecipe(recipe) {
     if (!recipe) {
       display.innerHTML = `
      <div class="row align-items-center justify-content-center text-center">
        <div class="col-sm-8 col-md-6 col-lg-4">
          <div class="card mb-5">
            <div class="card-body">
              <h5 class="card-title">No Matching Recipe</h5>
              <p class="card-text">Try chaging some parameters and spin again!</p>
            </div>
          </div>
        </div>
      </div>`;
     } else {
       const placeholder = '/images/recipe-placeholder.png';
       const image = (recipe.recipe_image_url == null) ? placeholder : recipe.recipe_image_url;

       display.innerHTML = `
       <div class="row align-items-center justify-content-center text-center">
        <div class="col-sm-8 col-md-6 col-lg-4">
          <div class="card mb-5">
            <a href="/recipes/${recipe.recipe_id}">
              <img class="card-img-top" src="${image}">
            </a>
            <div class="card-body">
              <h5 class="card-title">${recipe.recipe_name}</h5>
              <p class="card-text">${recipe.recipe_description}</p>
              <span class="card-thumbs text-right">
                <i class="far fa-thumbs-up recipe-like" id="recipe-<%= recipes[i].recipe_id %>-like"></i>
                <i class="far fa-thumbs-down recipe-dislike" id="recipe-<%= recipes[i].recipe_id %>-dislike"></i>
              </span>
            </div>
          </div>
        </div>
      </div>`;
     }
   }

 });
