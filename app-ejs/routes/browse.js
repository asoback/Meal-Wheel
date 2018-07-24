var mysql = require('../bin/dbcon.js');

const express = require('express');
const router = express.Router();

/* GET browse page. */
router.get('/', (req, res, next) => {
	mysql.pool.query('SELECT cuisine_id, cuisine_name FROM cuisine', function(err, rows, fields){
		const cuisines = rows;
		mysql.pool.query('SELECT recipe_category_id, recipe_category_name FROM recipe_category', function(err, rows, fields){
			const categories = rows;
			mysql.pool.query('SELECT dietary_restriction_id, dietary_restriction_name FROM dietary_restriction', function(err, rows, fields){
				const diets = rows;
				mysql.pool.query('SELECT recipe_id, recipe_image_url, recipe_name, recipe_description FROM recipe', function(err, rows, fields){
				const recipes = rows;
					res.render('browse', {
					    page: 'Browse Recipes',
					    menuId: 'browse',
					    cuisines: cuisines,
					    categories: categories,
					    diets: diets,
					    recipes: recipes,
				  	});
				});
			});
		});
	});
});

module.exports = router;
