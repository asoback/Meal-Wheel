const express = require('express');
const router = express.Router();
const Helpers = require('../helpers');

const Ingredients = require('../controllers/Ingredient');
const FoodGroups = require('../controllers/FoodGroup');

/* GET ingredient admin page. */
router.get('/', (req, res, next) => {
  let context;

  if (req.query.limit && req.query.offset) {
    context = Helpers.sanitize(req.query);
  } else {
    context = { limit: 100, offset: 0 };
  }

  Ingredients.getCount((err, ingredients) => {
    context.total = ingredients.total;

    Ingredients.getByRange(context, (err, ingredients) => {
      FoodGroups.getAll((err, foodGroups) => {

        res.render('ingredient', {
          page: 'Ingredients',
          sidebarId: '#nav-ingredients',
          data: ingredients,
          foodGroups: foodGroups,
          session: req.session,
          context: context,
        });
      });
    });
  });
});


router.post('/', (req, res, next) => {
  console.log(req.body);
  Ingredients.addNew(req.body, (err, result) => {
    res.send(err || result);
  });
});


router.delete('/:id', (req, res, next) => {
  Ingredients.deleteById(req.params.id, (err, result) => {
    res.send(err || result);
  });
});


router.put('/:id', (req, res, next) => {
  Ingredients.updateById(req.params.id, req.body, (err, result) => {
    res.send(err || result);
  });
});


module.exports = router;
