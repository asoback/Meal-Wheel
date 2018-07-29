const express = require('express');
const router = express.Router();


/* GET new user page. */
router.get('/', (req, res, next) => {
  res.render('newUser', {
    page: 'Sign Up',
    menuId: 'newUser',
  });
});

module.exports = router;
