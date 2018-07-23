/*
* Meal Wheel DDQ
* CS340
* Andrew Soback
* Taylor Jones
*/


-- USE cs340_jonest6;
-- USE cs340_sobacka;


/************************************************
* CREATE TABLES
***********************************************/
/* The tables are dropped in the reverse order that they're created
 in order to avoid any issues with foreign key dependencies either
 while creating or deleting. */
DROP TABLE IF EXISTS user_significant_recipe;
DROP TABLE IF EXISTS recipe_cuisine;
DROP TABLE IF EXISTS recipe_ingredient;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS food_group_dietary_restriction;
DROP TABLE IF EXISTS recipe_category;
DROP TABLE IF EXISTS recipe_significance_type;
DROP TABLE IF EXISTS unit_of_measure;
DROP TABLE IF EXISTS cuisine;
DROP TABLE IF EXISTS dietary_restriction;
DROP TABLE IF EXISTS ingredient;
DROP TABLE IF EXISTS food_group;
DROP TABLE IF EXISTS app_user;


--
-- Table structure for app_user
--
CREATE TABLE app_user (
  user_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  user_name varchar(150) NOT NULL,
  user_email varchar(150) NOT NULL,
  user_password varchar(20) NOT NULL,
  UNIQUE KEY user_email (user_email)
) ENGINE = InnoDB;

--
-- Table structure for ingredient_category
--
CREATE TABLE food_group(
  food_group_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  food_group_name varchar(50) NOT NULL,
  UNIQUE KEY food_group_name (food_group_name)
) ENGINE = InnoDB;

--
-- Table structure for ingredient
--
CREATE TABLE ingredient (
  ingredient_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  ingredient_name varchar(255) NOT NULL,
  food_group_id int(11) NOT NULL,
  FOREIGN KEY (food_group_id) REFERENCES food_group(food_group_id) ON UPDATE CASCADE ON DELETE CASCADE,
  UNIQUE KEY ingredient_name (ingredient_name)
) ENGINE = InnoDB;

--
-- Table structure for dietary_restriction
--
CREATE TABLE dietary_restriction (
  dietary_restriction_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  dietary_restriction_name varchar(35) NOT NULL,
  UNIQUE KEY dietary_restriction_name (dietary_restriction_name)
) ENGINE = InnoDB;

--
-- Table structure for cuisine
--
CREATE TABLE cuisine (
  cuisine_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  cuisine_name varchar(35) NOT NULL,
  UNIQUE KEY cuisine_name (cuisine_name)
) ENGINE = InnoDB;

--
-- Table structure for unit_of_measure
--
CREATE TABLE unit_of_measure (
  unit_of_measure_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  unit_of_measure_name varchar(25) NOT NULL,
  unit_of_measure_abbrev varchar(5),
  UNIQUE KEY unit_of_measure_name (unit_of_measure_name)
) ENGINE = InnoDB;

--
-- Table structure for recipe_significance_type
--
CREATE TABLE recipe_significance_type (
  recipe_significance_type_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  recipe_significance_type_name varchar(15) NOT NULL,
  UNIQUE KEY recipe_significance_type_name (recipe_significance_type_name)
) ENGINE = InnoDB;

--
-- Table structure for recipe category
--
CREATE TABLE recipe_category (
  recipe_category_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  recipe_category_name varchar(35) NOT NULL,
  UNIQUE KEY recipe_category_name (recipe_category_name)
) ENGINE = InnoDB;

--
-- Table structure for ingredient_dietary_restriction
--
CREATE TABLE food_group_dietary_restriction (
  food_group_id int(11) NOT NULL,
  dietary_restriction_id int(11) NOT NULL,
  PRIMARY KEY (food_group_id, dietary_restriction_id),
  FOREIGN KEY (food_group_id) REFERENCES food_group(food_group_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (dietary_restriction_id) REFERENCES dietary_restriction(dietary_restriction_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;

--
-- Table structure for recipe
--
CREATE TABLE recipe (
  recipe_id int(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
  recipe_name varchar(255) NOT NULL,
  recipe_image_url varchar(255),
  recipe_instructions text,
  recipe_description text,
  user_id int(11),
  recipe_category_id int(11) NOT NULL,
  created_date timestamp DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE SET NULL,
  FOREIGN KEY (recipe_category_id) REFERENCES recipe_category(recipe_category_id) ON UPDATE CASCADE ON DELETE CASCADE,
  UNIQUE KEY recipe_name (recipe_name)
) ENGINE = InnoDB;

--
-- Table structure for recipe_ingredient
--
CREATE TABLE recipe_ingredient (
  recipe_id int(11) NOT NULL,
  ingredient_id int(11) NOT NULL,
  amount float NOT NULL DEFAULT 1,
  unit_of_measure_id int(11),
  PRIMARY KEY (recipe_id, ingredient_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (ingredient_id) REFERENCES ingredient(ingredient_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (unit_of_measure_id) REFERENCES unit_of_measure(unit_of_measure_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;

--
-- Table structure for recipe_cuisine
--
CREATE TABLE recipe_cuisine (
  recipe_id int(11) NOT NULL,
  cuisine_id int(11) NOT NULL,
  PRIMARY KEY (recipe_id, cuisine_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (cuisine_id) REFERENCES cuisine(cuisine_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;

--
-- Table structure for user_significant_recipe
--
CREATE TABLE user_significant_recipe (
  user_id int(11) NOT NULL,
  recipe_id int(11) NOT NULL,
  recipe_significance_type_id int(11) NOT NULL,
  PRIMARY KEY (user_id, recipe_id),
  FOREIGN KEY (user_id) REFERENCES app_user(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (recipe_significance_type_id) REFERENCES recipe_significance_type(recipe_significance_type_id) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE = InnoDB;




/************************************************
* SAMPLE DATA
***********************************************/

-- Cuisines
INSERT INTO
  cuisine (cuisine_name)
VALUES
  ('African'),
  ('Indian'),
  ('French'),
  ('American'),
  ('European'),
  ('Italian'),
  ('Jewish'),
  ('Mexican'),
  ('Latin American'),
  ('Tex-Mex'),
  ('Thai'),
  ('Vietnamese'),
  ('Spanish'),
  ('Greek'),
  ('Chinese'),
  ('Japanese'),
  ('Asian'),
  ('Moroccan'),
  ('Caribbean');
  

  -- Recipe Categories
INSERT INTO
  recipe_category (recipe_category_name)
VALUES
  ('Main Course'),
  ('Snack'),
  ('Beverage'),
  ('Dessert'),
  ('Side Dish');
  

  -- Unit of measure
INSERT INTO
  unit_of_measure (unit_of_measure_name, unit_of_measure_abbrev)
VALUES
  ('Cup', 'c'),
  ('TableSpoon', 'tbsp'),
  ('Teaspoon', 'tsp'),
  ('Ounce', 'oz'),
  ('Slice', 'Slice'),
  ('Pint', 'pt'),
  ('Quart', 'qt'),
  ('Milliliter', 'mL'),
  ('Pound', 'lb'),
  ('Gallon', 'gal'),
  ('Drop', 'drop'),
  ('Pinch', 'pinch'),
  ('Dash', 'dash'),
  ('Liter', 'L'),
  ('Milligram', 'mg'),
  ('Gram', 'g'),
  ('Kilogram', 'kg'),
  ('Fluid Ounce', 'fl oz');
  

  -- Recipe Significance Type
INSERT INTO
  recipe_significance_type (recipe_significance_type_name)
VALUES
  ('Liked'),
  ('Disliked');
  

  -- User
INSERT INTO
  `app_user` (user_name, user_email, user_password)
VALUES
  ('Andrew Soback','sobacka@oregonstate.edu','12345'),
  ('Taylor Jones','jonest6@oregonstate.edu','12345'),
  ('user', 'user@example.com', 'password');
  

  -- Food Groups
INSERT INTO
  `food_group` (food_group_id, food_group_name)
VALUES
  (0100, 'Dairy & Egg Products'),
  (0200, 'Spices & Herbs'),
  (0300, 'Baby Foods'),
  (0400, 'Fats & Oils'),
  (0500, 'Poultry Products'),
  (0600, 'Soups, Sauces, & Gravies'),
  (0700, 'Sausages & Luncheon Meats'),
  (0800, 'Breakfast Cereals'),
  (0900, 'Fruits & Fruit Juices'),
  (1000, 'Pork Products'),
  (1100, 'Vegetables & Vegetable Products'),
  (1200, 'Nut & Seed Products'),
  (1300, 'Beef Products'),
  (1400, 'Beverages'),
  (1500, 'Finfish & Shellfish Products'),
  (1600, 'Legumes & Legume Products'),
  (1700, 'Lamb, Veal, and Game Products'),
  (1800, 'Baked Products'),
  (1900, 'Sweets'),
  (2000, 'Cereal Grains and Pasta'),
  (2100, 'Fast Foods'),
  (2200, 'Meals, Entrees, & Side Dishes'),
  (2500, 'Snacks'),
  (3500, 'American Indian/Alaska Native Foods'),
  (3600, 'Restaurant Foods');
  

  -- Ingredients
INSERT INTO
  `ingredient` (ingredient_name, food_group_id)
VALUES
  ('Abiyuch', 0900),
  ('Acerola', 0900),
  ('Acerola juice', 0900),
  ('Acorn stew', 3500),
  ('Agave', 3500),
  ('Agutuk', 3500),
  ('Alcoholic beverage', 1400),
  ('Alfalfa seeds', 1100),
  ('Amaranth grain', 2000),
  ('Amaranth leaves', 1100),
  ('Animal fat', 0400),
  ('Apple juice', 0900),
  ('Apples', 0900),
  ('Applesauce', 0900),
  ('Apricot nectar', 0900),
  ('Apricots', 0900),
  ('Arrowhead', 1100),
  ('Arrowroot', 1100),
  ('Arrowroot flour', 2000),
  ('Artichokes', 1100),
  ('Artificial Blueberry Muffin Mix', 1800),
  ('Arugula', 1100),
  ('Ascidians', 3500),
  ('Asparagus', 1100),
  ('Avocados', 0900),
  ('Baby food', 0300),
  ('Bacon', 1000),
  ('Bacon and beef sticks', 0700),
  ('Bacon bits', 1600),
  ('Bagel', 1800),
  ('Baking chocolate', 1900),
  ('Balsam-pear', 1100),
  ('Bamboo shoots', 1100),
  ('Bananas', 0900),
  ('Barbecue loaf', 0700),
  ('Barley', 2000),
  ('Barley flour or meal', 2000),
  ('Barley malt flour', 2000),
  ('Basil', 0200),
  ('Bean beverage', 1600),
  ('Beans', 1600),
  ('Bear', 3500),
  ('Beef', 1300),
  ('Beef Pot Pie', 2200),
  ('Beef broth and tomato juice', 1400),
  ('Beef macaroni with tomato sauce', 2200),
  ('Beef sausage', 0700),
  ('Beef stew', 2200),
  ('Beerwurst', 0700),
  ('Beet greens', 1100),
  ('Beets', 1100),
  ('Biscuits', 1800),
  ('Bison', 1700),
  ('Blackberries', 0900),
  ('Blackberry juice', 0900),
  ('Blood sausage', 0700),
  ('Blueberries', 0900),
  ('Bockwurst', 0700),
  ('Bologna', 0700),
  ('Borage', 1100),
  ('Boysenberries', 0900),
  ('Bratwurst', 0700),
  ('Braunschweiger', 0700),
  ('Bread', 1800),
  ('Bread crumbs', 1800),
  ('Bread sticks', 1800),
  ('Bread stuffing', 1800),
  ('Breadfruit', 0900),
  ('Breakfast tart', 1800),
  ('Broccoli', 1100),
  ('Broccoli raab', 1100),
  ('Brussels sprouts', 1100),
  ('Buckwheat', 2000),
  ('Buckwheat flour', 2000),
  ('Buckwheat groats', 2000),
  ('Buffalo', 3500),
  ('Bulgur', 2000),
  ('Burdock root', 1100),
  ('Burrito', 2200),
  ('Butter', 0400),
  ('Butter oil', 0100),
  ('Butter replacement', 0400),
  ('Butterbur', 1100),
  ('Cabbage', 1100),
  ('Cake mix', 1800),
  ('Canada Goose', 0500),
  ('Canadian bacon', 1000),
  ('Candied fruit', 0900),
  ('Candies', 1900),
  ('Capers', 0200),
  ('Carambola', 0900),
  ('Carbonated beverage', 1400),
  ('Cardoon', 1100),
  ('Caribou', 3500),
  ('Carissa', 0900),
  ('Carob flour', 1600),
  ('Carob-flavor beverage mix', 1400),
  ('Carrot', 1100),
  ('Carrot juice', 1100),
  ('Carrots', 1100),
  ('Cassava', 1100),
  ('Catsup', 1100),
  ('Cattail', 3500),
  ('Cauliflower', 1100),
  ('Celeriac', 1100),
  ('Celery', 1100),
  ('Celery flakes', 1100),
  ('Celtuce', 1100),
  ('Cereals', 0800),
  ('Chard', 1100),
  ('Chayote', 1100),
  ('Cheese', 0100),
  ('Cheese food', 0100),
  ('Cheese product', 0100),
  ('Cheese puffs and twists', 2500),
  ('Cheese sauce', 0100),
  ('Cheese spread', 0100),
  ('Cheese substitute', 0100),
  ('Cheesecake commercially prepared', 1800),
  ('Cheesecake prepared from mix', 1800),
  ('Cheesefurter', 0700),
  ('Cherimoya', 0900),
  ('Cherries', 0900),
  ('Chewing gum', 1900),
  ('Chicken', 0500),
  ('Chicken breast', 0700),
  ('Chicken breast tenders', 0500),
  ('Chicken patty', 0500),
  ('Chicken pot pie', 2200),
  ('Chicken roll', 0700),
  ('Chicken spread', 0700),
  ('Chicken tenders', 2200),
  ('Chickpea flour', 1600),
  ('Chickpeas', 1600),
  ('Chicory', 1100),
  ('Chicory greens', 1100),
  ('Chicory roots', 1100),
  ('Chilchen', 3500),
  ('Child formula', 0300),
  ('Chili', 2200),
  ('Chili con carne with beans', 2200),
  ('Chili with beans', 2200),
  ('Chiton', 3500),
  ('Chives', 1100),
  ('Chocolate', 1900),
  ('Chocolate syrup', 1400),
  ('Chocolate-flavor beverage mix', 1400),
  ('Chocolate-flavor beverage mix for milk', 1400),
  ('Chocolate-flavored drink', 1400),
  ('Chocolate-flavored hazelnut spread', 1900),
  ('Chokecherries', 3500),
  ('Chorizo', 0700),
  ('Chrysanthemum', 1100),
  ('Chrysanthemum leaves', 1100),
  ('Cinnamon buns', 1800),
  ('Citrus fruit juice drink', 1400),
  ('Clam and tomato juice', 1400),
  ('Clementines', 0900),
  ('Cloudberries', 3500),
  ('Cockles', 3500),
  ('Cocktail mix', 1400),
  ('Cocoa', 1900),
  ('Cocoa mix', 1400),
  ('Coffee', 1400),
  ('Coffee and cocoa powder', 1400),
  ('Coffee substitute', 1400),
  ('Coffeecake', 1800),
  ('Collards', 1100),
  ('Cookie', 1800),
  ('Cookies', 1800),
  ('Coriander leaves', 1100),
  ('Corn', 1100),
  ('Corn bran', 2000),
  ('Corn dogs', 2200),
  ('Corn flour', 2000),
  ('Corn grain', 2000),
  ('Corn pudding', 1100),
  ('Corn with red and green peppers', 1100),
  ('Corned beef and potatoes in tortilla', 3500),
  ('Corned beef loaf', 0700),
  ('Cornmeal', 2000),
  ('Corn Salad', 1100),
  ('Cornstarch', 2000),
  ('Couscous', 2000),
  ('Cowpeas', 1600),
  ('Crabapples', 0900),
  ('Cracker meal', 1800),
  ('Crackers', 1800),
  ('Cranberries', 0900),
  ('Cranberry juice', 0900),
  ('Cranberry juice cocktail', 1400),
  ('Cranberry sauce', 0900),
  ('Cranberry-apple juice drink', 1400),
  ('Cranberry-apricot juice drink', 1400),
  ('Cranberry-grape juice drink', 1400),
  ('Cranberry-orange relish', 0900),
  ('Cream', 0100),
  ('Cream puff', 1800),
  ('Cream puff shell', 1800),
  ('Cream substitute', 0100),
  ('Creamy dressing', 0400),
  ('Cress', 1100),
  ('Croissants', 1800),
  ('Croutons', 1800),
  ('Crustaceans', 1500),
  ('Cucumber', 1100),
  ('Currants', 0900),
  ('Custard-apple', 0900),
  ('Dairy', 0100),
  ('Dairy drink mix', 1400),
  ('Dandelion greens', 1100),
  ('Danish pastry', 1800),
  ('Dates', 0900),
  ('Deer', 3500),
  ('Dill weed', 0200),
  ('Dip', 0600),
  ('Doughnuts', 1800),
  ('Dove', 0500),
  ('Drumstick leaves', 1100),
  ('Drumstick pods', 1100),
  ('Duck', 0500),
  ('Dulce de Leche', 0100),
  ('Durian', 0900),
  ('Dutch brand loaf', 0700),
  ('Edamame', 1100),
  ('Egg', 0100),
  ('Egg Mix', 0100),
  ('Egg custards', 1900),
  ('Egg rolls', 2200),
  ('Egg substitute', 0100),
  ('Eggnog', 0100),
  ('Eggnog-flavor mix', 1400),
  ('Eggplant', 1100),
  ('Eggs', 0100),
  ('Elderberries', 0900),
  ('Elk', 3500),
  ('Emu', 0500),
  ('Endive', 1100),
  ('English muffins', 1800),
  ('Epazote', 1100),
  ('Eppaw', 1100),
  ('Falafel', 1600),
  ('Fat', 0400),
  ('Fat free ice cream', 0100),
  ('Feijoa', 0900),
  ('Fennel', 1100),
  ('Fiddlehead ferns', 1100),
  ('Figs', 0900),
  ('Fireweed', 1100),
  ('Fish', 1500),
  ('Fish broth', 0600),
  ('Fish oil', 0400),
  ('Fish sticks', 1600),
  ('Flan', 1900),
  ('Fluid replacement', 0300),
  ('Focaccia', 1800),
  ('Formulated bar', 2500),
  ('Frankfurter', 0700),
  ('French toast', 1800),
  ('Frijoles rojos volteados', 1600),
  ('Frog legs', 1500),
  ('Frostings', 1900),
  ('Frozen novelties', 1900),
  ('Frozen yogurts', 1900),
  ('Fruit butters', 1900),
  ('Fruit cocktail', 0900),
  ('Fruit flavored drink', 1400),
  ('Fruit flavored drink containing less than 3% fruit juice', 1400),
  ('Fruit juice drink', 1400),
  ('Fruit punch drink', 1400),
  ('Fruit punch juice drink', 1400),
  ('Fruit punch-flavor drink', 1400),
  ('Fruit salad', 0900),
  ('Fruit-flavored drink', 1400),
  ('Frybread', 3500),
  ('Fungi', 1100),
  ('Game meat', 1700),
  ('Garlic', 1100),
  ('Garlic bread', 1800),
  ('Gelatin desserts', 1900),
  ('Gelatins', 1900),
  ('Ginger root', 1100),
  ('Goat', 1700),
  ('Goose', 0500),
  ('Gooseberries', 0900),
  ('Gourd', 1100),
  ('Granola bar', 2500),
  ('Grape drink', 1400),
  ('Grape juice', 0900),
  ('Grape leaves', 1100),
  ('Grapefruit', 0900),
  ('Grapefruit juice', 0900),
  ('Grapes', 0900),
  ('Gravy', 0600),
  ('Ground turkey', 0500),
  ('Ground Cherries', 0900),
  ('Guanabana nectar', 0900),
  ('Guava nectar', 0900),
  ('Guava sauce', 0900),
  ('Guavas', 0900),
  ('Guinea hen', 0500),
  ('Gums', 1900),
  ('Ham', 0700),
  ('Ham and cheese spread', 0700),
  ('Ham salad spread', 0700),
  ('Hazelnuts', 3500),
  ('Headcheese', 0700),
  ('Hearts of palm', 1100),
  ('Hibiscus tea', 1400),
  ('Hominy', 2000),
  ('Honey', 1900),
  ('Honey roll sausage', 0700),
  ('Horned melon', 0900),
  ('Horseradish', 0200),
  ('Huckleberries', 3500),
  ('Hummus', 1600),
  ('Hush puppies', 1800),
  ('Hyacinth beans', 1600),
  ('Hyacinth-beans', 1100),
  ('Ice cream', 0100),
  ('Ice cream bar', 0100),
  ('Ice cream cone', 0100),
  ('Ice cream cookie sandwich', 0100),
  ('Ice cream sandwich', 0100),
  ('Imitation cheese', 0100),
  ('Incaparina', 0800),
  ('Infant formula', 0300),
  ('Jackfruit', 0900),
  ('Jams and preserves', 1900),
  ('Java-plum', 0900),
  ('Jellyfish', 1500),
  ('Juice', 0900),
  ('Juice Smoothie', 0900),
  ('Jujube', 0900),
  ('Jute', 1100),
  ('Kale', 1100),
  ('Kanpyo', 1100),
  ('Keikitos', 1800),
  ('Kielbasa', 0700),
  ('Kiwifruit', 0900),
  ('Knackwurst', 0700),
  ('Kohlrabi', 1100),
  ('Kumquats', 0900),
  ('Lamb', 1700),
  ('Lambs quarters', 1100),
  ('Lambsquarters', 1100),
  ('Lard', 0400),
  ('Lasagna', 2200),
  ('Lasagna with meat sauce', 2200),
  ('Lean Pockets', 2200),
  ('Leavening agents', 1800),
  ('Lebanon bologna', 0700),
  ('Leeks', 1100),
  ('Lemon grass', 1100),
  ('Lemon juice', 0900),
  ('Lemon peel', 0900),
  ('Lemonade', 1400),
  ('Lemonade-flavor drink', 1400),
  ('Lemons', 0900),
  ('Lentils', 1600),
  ('Lettuce', 1100),
  ('Light Ice Cream', 2100),
  ('Lima beans', 1600),
  ('Lime juice', 0900),
  ('Limeade', 1400),
  ('Limes', 0900),
  ('Litchis', 0900),
  ('Liver cheese', 0700),
  ('Liver sausage', 0700),
  ('Liverwurst spread', 0700),
  ('Loganberries', 0900),
  ('Longans', 0900),
  ('Loquats', 0900),
  ('Lotus root', 1100),
  ('Lupins', 1600),
  ('Luxury loaf', 0700),
  ('Macaroni', 2000),
  ('Malabar spinach', 1100),
  ('Malt beverage', 1400),
  ('Malted drink mix', 1400),
  ('Mango nectar', 0900),
  ('Mangos', 0900),
  ('Mangosteen', 0900),
  ('Maraschino cherries', 0900),
  ('Margarine', 0400),
  ('Margarine Spread', 0400),
  ('Marmalade', 1900),
  ('Mashu roots', 3500),
  ('Mayonnaise', 0400),
  ('Meal supplement drink', 1400),
  ('Meat drippings', 0400),
  ('Meat extender', 1600),
  ('Meatballs', 0700),
  ('Meatless Meatballs', 1600),
  ('Melon', 3500),
  ('Melon balls', 0900),
  ('Melons', 0900),
  ('Milk', 0100),
  ('Milk and cereal bar', 2500),
  ('Milk dessert', 1900),
  ('Milk dessert bar', 0100),
  ('Milk shakes', 0100),
  ('Milk substitutes', 0100),
  ('Millet', 2000),
  ('Millet flour', 2000),
  ('Miso', 1600),
  ('Mixed vegetable and fruit juice drink', 1400),
  ('Molasses', 1900),
  ('Mollusks', 1500),
  ('Moose', 3500),
  ('Mortadella', 0700),
  ('Mothbeans', 1600),
  ('Mother''s loaf', 0700),
  ('Mountain yam', 1100),
  ('Muffin', 1800),
  ('Mulberries', 0900),
  ('Mung beans', 1600),
  ('Mush', 3500),
  ('Mushrooms', 1100),
  ('Mustard', 0200),
  ('Mustard greens', 1100),
  ('Mustard spinach', 1100),
  ('Mutton', 3500),
  ('Nance', 0900),
  ('Naranjilla pulp', 0900),
  ('Natto', 1600),
  ('Nectarines', 0900),
  ('New Zealand spinach', 1100),
  ('New england brand sausage', 0700),
  ('Noodles', 2000),
  ('Nopales', 1100),
  ('Nuts', 1200),
  ('Oat bran', 2000),
  ('Oat flour', 2000),
  ('Oats', 2000),
  ('Octopus', 3500),
  ('Oil', 0400),
  ('Okara', 1600),
  ('Okra', 1100),
  ('Olive loaf', 0700),
  ('Olives', 0900),
  ('Onion rings', 1100),
  ('Onions', 1100),
  ('Oopah', 3500),
  ('Orange Pineapple Juice Blend', 0900),
  ('Orange and apricot juice drink', 1400),
  ('Orange breakfast drink', 1400),
  ('Orange drink', 1400),
  ('Orange juice', 0900),
  ('Orange juice drink', 1400),
  ('Orange peel', 0900),
  ('Orange-flavor drink', 1400),
  ('Orange-grapefruit juice', 0900),
  ('Oranges', 0900),
  ('Ostrich', 0500),
  ('Oven-roasted chicken breast roll', 0700),
  ('Owl', 3500),
  ('Pan Dulce', 1800),
  ('Pancakes', 1800),
  ('Pancakes plain', 1800),
  ('Papad', 1600),
  ('Papaya', 0900),
  ('Papaya nectar', 0900),
  ('Parmesan cheese topping', 0100),
  ('Parsley', 1100),
  ('Parsnips', 1100),
  ('Passion-fruit', 0900),
  ('Passion-fruit juice', 0900),
  ('Pasta', 2000),
  ('Pasta mix', 2200),
  ('Pasta with tomato sauce', 2200),
  ('Pastrami', 0700),
  ('Pastry', 1800),
  ('Pate', 0700),
  ('Pate de foie gras', 0500),
  ('Peach nectar', 0900),
  ('Peaches', 0900),
  ('Peanut butter', 1600),
  ('Peanut flour', 1600),
  ('Peanut spread', 1600),
  ('Peanuts', 1600),
  ('Pear nectar', 0900),
  ('Pears', 0900),
  ('Peas', 1100),
  ('Peas and carrots', 1100),
  ('Peas and onions', 1100),
  ('Pectin', 1900),
  ('Pepeao', 1100),
  ('Pepper', 1100),
  ('Peppered loaf', 0700),
  ('Peppermint', 0200),
  ('Pepperoni', 0700),
  ('Peppers', 1100),
  ('Persimmons', 0900),
  ('Pheasant', 0500),
  ('Phyllo dough', 1800),
  ('Pickle and pimiento loaf', 0700),
  ('Pickle relish', 1100),
  ('Pickles', 1100),
  ('Picnic loaf', 0700),
  ('Pie', 1800),
  ('Pie crust', 1800),
  ('Pie fillings', 1900),
  ('Pigeonpeas', 1100),
  ('Piki bread', 3500),
  ('Pimento', 1100),
  ('Pineapple', 0900),
  ('Pineapple and grapefruit juice drink', 1400),
  ('Pineapple and orange juice drink', 1400),
  ('Pineapple juice', 0900),
  ('Pinon Nuts', 3500),
  ('Pitanga', 0900),
  ('Pizza', 2100),
  ('Pizza rolls', 2200),
  ('Plantains', 0900),
  ('Plums', 0900),
  ('Poi', 1100),
  ('Pokeberry shoots', 1100),
  ('Polish sausage', 0700),
  ('Pomegranate juice', 0900),
  ('Pomegranates', 0900),
  ('Popcorn', 2500),
  ('Popovers', 1800),
  ('Pork', 1000),
  ('Pork and beef sausage', 0700),
  ('Pork and turkey sausage', 0700),
  ('Pork loin', 1000),
  ('Pork sausage', 0700),
  ('Pork sausage rice links', 0700),
  ('Potato chips', 2500),
  ('Potato flour', 1100),
  ('Potato pancakes', 1100),
  ('Potato puffs', 1100),
  ('Potato salad', 1100),
  ('Potato soup', 0600),
  ('Potato', 1100),
  ('Prairie Turnips', 3500),
  ('Pretzels', 2500),
  ('Prickly pears', 0900),
  ('Protein supplement', 0100),
  ('Prune juice', 0900),
  ('Prune puree', 0900),
  ('Prunes', 0900),
  ('Pudding', 1900),
  ('Puff pastry', 1800),
  ('Pulled pork in barbecue sauce', 2200),
  ('Pummelo', 0900),
  ('Pumpkin', 1100),
  ('Pumpkin flowers', 1100),
  ('Pumpkin leaves', 1100),
  ('Pumpkin pie mix', 1100),
  ('Purslane', 1100),
  ('Quail', 0500),
  ('Queso cotija', 0100),
  ('Quinces', 0900),
  ('Quinoa', 2000),
  ('Radicchio', 1100),
  ('Radish seeds', 1100),
  ('Radishes', 1100),
  ('Raisins', 0900),
  ('Rambutan', 0900),
  ('Raspberries', 0900),
  ('Ravioli', 2200),
  ('Ready-to-drink reduced fat milk beverage', 1400),
  ('Reddi Wip Fat Free Whipped Topping', 0100),
  ('Refried beans', 1600),
  ('Rennin', 1900),
  ('Restaurant', 3600),
  ('Rhubarb', 0900),
  ('Rice', 2000),
  ('Rice and Wheat cereal bar', 2500),
  ('Rice and vermicelli mix', 2200),
  ('Rice bowl with chicken', 2200),
  ('Rice bran', 2000),
  ('Rice cake', 2500),
  ('Rice drink', 1400),
  ('Rice flour', 2000),
  ('Rice noodles', 2000),
  ('Roast beef', 0700),
  ('Rolls', 1800),
  ('Rose Hips', 3500),
  ('Rose-apples', 0900),
  ('Roselle', 0900),
  ('Rosemary', 0200),
  ('Rowal', 0900),
  ('Ruffed Grouse', 0500),
  ('Rutabagas', 1100),
  ('Rye flour', 2000),
  ('Rye grain', 2000),
  ('Salad dressing', 0400),
  ('Salami', 0700),
  ('Salmon', 1500),
  ('Salmonberries', 3500),
  ('Salsify', 1100),
  ('Salt', 0200),
  ('Sapodilla', 0900),
  ('Sapote', 0900),
  ('Sauce', 0600),
  ('Sauerkraut', 1100),
  ('Sausage', 0700),
  ('Tofu Veggie Sausage', 1600),
  ('School Lunch Pizza', 2100),
  ('Scrapple', 0700),
  ('Sea cucumber', 3500),
  ('Sea lion', 3500),
  ('Seal', 3500),
  ('Seasoning mix', 0200),
  ('Seaweed', 1100),
  ('Seeds', 1200),
  ('Semolina', 2000),
  ('Sesbania flower', 1100),
  ('Shake', 1400),
  ('Shallots', 1100),
  ('Sherbet', 1900),
  ('Shortening', 0400),
  ('Shortening bread', 0400),
  ('Shortening cake mix', 0400),
  ('Shortening confectionery', 0400),
  ('Smelt', 3500),
  ('Smoked link sausage', 0700),
  ('Sorghum flour', 2000),
  ('Sorghum grain', 2000),
  ('Sour cream', 0100),
  ('Sour dressing', 0100),
  ('Sourdock', 3500),
  ('Soursop', 0900),
  ('Soy flour', 1600),
  ('Soy meal', 1600),
  ('Soy protein concentrate', 1600),
  ('Soy protein isolate', 1600),
  ('Soy sauce', 1600),
  ('Soy sauce made from hydrolyzed vegetable protein', 1600),
  ('Soy sauce made from soy', 1600),
  ('Soy sauce made from soy and wheat', 1600),
  ('Soybean', 1600),
  ('Soymilk', 1600),
  ('Spaghetti', 2000),
  ('Spanish rice mix', 2200),
  ('Spearmint', 0200),
  ('Spelt', 2000),
  ('Spices', 0200),
  ('Spinach', 1100),
  ('Spinach souffle', 1100),
  ('Split pea soup', 0600),
  ('Squab', 0500),
  ('Squash', 1100),
  ('Squirrel', 3500),
  ('Steelhead trout', 3500),
  ('Stinging Nettles', 3500),
  ('Strawberries', 0900),
  ('Strawberry-flavor beverage mix', 1400),
  ('Strudel', 1800),
  ('Succotash', 1100),
  ('Sugar', 1900),
  ('Sugar-apples', 0900),
  ('Swamp cabbage', 1100),
  ('Sweet Potato puffs', 1100),
  ('Sweet potato', 1100),
  ('Sweet potato leaves', 1100),
  ('Sweet rolls', 1800),
  ('Sweetener', 1900),
  ('Sweeteners', 1900),
  ('Swisswurst', 0700),
  ('Maple Syrup', 1900),
  ('Taco shells', 1800),
  ('Tamales', 3500),
  ('Tamarind nectar', 0900),
  ('Tamarinds', 0900),
  ('Tangerine juice', 0900),
  ('Tangerines', 0900),
  ('Tapioca', 2000),
  ('Taquitos', 2200),
  ('Taro', 1100),
  ('Taro leaves', 1100),
  ('Taro shoots', 1100),
  ('Tea', 1400),
  ('Teff', 2000),
  ('Tempeh', 1600),
  ('Tennis Bread', 3500),
  ('Thuringer', 0700),
  ('Thyme', 0200),
  ('Toaster pastries', 1800),
  ('Toddler formula', 0300),
  ('Tofu', 1600),
  ('Tofu yogurt', 1600),
  ('Tomatillos', 1100),
  ('Tomato and vegetable juice', 1100),
  ('Tomato juice', 1100),
  ('Tomato powder', 1100),
  ('Tomato products', 1100),
  ('Tomato sauce', 1100),
  ('Tomato', 1100),
  ('Toppings', 1900),
  ('Tortellini', 2200),
  ('Tortilla', 3500),
  ('Tortilla chips', 2500),
  ('Tortillas', 1800),
  ('Tostada shells', 1800),
  ('Tostada with guacamole', 2100),
  ('Tree fern', 1100),
  ('Triticale', 2000),
  ('Triticale flour', 2000),
  ('Turkey', 0500),
  ('Turkey Lunch Meat', 0700),
  ('Turkey Pot Pie', 2200),
  ('Turkey and gravy', 0500),
  ('Turkey and pork sausage', 0700),
  ('Turkey bacon', 0700),
  ('Turkey breast', 0500),
  ('Turkey breast Lunch Meat', 0700),
  ('Turkey from whole', 0500),
  ('Turkey ham', 0700),
  ('Turkey patties', 0500),
  ('Turkey roast', 0500),
  ('Turkey roll', 0700),
  ('Turkey sausage', 0700),
  ('Turkey sticks', 0500),
  ('Turkey thigh', 0500),
  ('Turnip greens', 1100),
  ('Turnips', 1100),
  ('Turnover', 2200),
  ('Turtle', 1500),
  ('V8 SPLASH Juice Drinks', 1400),
  ('V8 SPLASH Smoothies', 1400),
  ('V8 V. FUSION Juices', 1400),
  ('Vanilla extract', 0200),
  ('Veal', 1700),
  ('Vegetable and fruit juice drink', 1400),
  ('Vegetable juice cocktail', 1100),
  ('Vegetable oil', 0400),
  ('Vegetable oil-butter spread', 0400),
  ('Vegetables', 1100),
  ('Vegetarian fillets', 1600),
  ('Vegetarian meatloaf or patties', 1600),
  ('Vegetarian stew', 1600),
  ('Veggie burgers or soyburgers', 1600),
  ('Vermicelli', 1600),
  ('Vinegar', 0200),
  ('Vine spinach', 1100),
  ('Vital wheat gluten', 2000),
  ('Nasoya', 1600),
  ('Nasoya Sprouted', 1600),
  ('Waffle', 1800),
  ('Waffles', 1800),
  ('Walrus', 3500),
  ('Wasabi', 1100),
  ('Water', 1400),
  ('Waterchestnuts', 1100),
  ('Watercress', 1100),
  ('Watermelon', 0900),
  ('Waxgourd', 1100),
  ('Whale', 3500),
  ('Wheat', 2000),
  ('Wheat bran', 2000),
  ('Wheat flour', 2000),
  ('Wheat germ', 2000),
  ('Whey', 0100),
  ('Whipped cream substitute', 0100),
  ('Whipped topping', 0100),
  ('Whiskey sour mix', 1400),
  ('Wild rice', 2000),
  ('Willow', 3500),
  ('Wine', 1400),
  ('Winged beans', 1600),
  ('Wocas', 3500),
  ('Wonton wrappers', 1800),
  ('Yachtwurst', 0700),
  ('Yam', 1100),
  ('Yambean', 1100),
  ('Yardlong beans', 1600),
  ('Yautia', 1100),
  ('Yeast extract spread', 1100),
  ('Yellow rice with seasoning', 2200),
  ('Yogurt', 0100),
  ('Yogurt parfait', 2100),
  ('Tequila', 1400),
  ('Orange Liqueur', 1400),
  ('Simple Syrup', 1400);
  

  -- Dietary Restriction
INSERT INTO
  dietary_restriction(dietary_restriction_name)
VALUES
  ('Lactose Intolerance'),
  ('Vegetarian'),
  ('Nut-Free');
  

  -- Food Group Dietary Restriction
INSERT INTO
  food_group_dietary_restriction(food_group_id, dietary_restriction_id)
VALUES
  (0100, 1),
  (0500, 2),
  (0700, 2),
  (1300, 2),
  (1500, 2),
  (1700, 2),
  (1200, 3);
  

  -- Recipe
INSERT INTO
  recipe (recipe_name,recipe_description,recipe_instructions,user_id,recipe_category_id)
VALUES
  ('BLT','Bacon, Lettuce, and Tomato Sandwich',NULL,1,1),
  ('Beef and Broccoli','”Traditional” Asian Dish',NULL,1,1),
  ('Watermelon Pitcher Margaritas','Delicious Margaritas designed to serve 5-6',NULL,2,3);
  

  -- Recipe Cuisine
INSERT INTO
  recipe_cuisine (recipe_id, cuisine_id)
VALUES
  (1, 4),
  (2, 15),
  (3, 8),
  (3, 9),
  (3, 10);
  

  -- Recipe Ingredient
INSERT INTO
  recipe_ingredient (recipe_id, ingredient_id, amount, unit_of_measure_id)
VALUES
  (1, 27, 3, 5),
  (1, 361, 1, NULL),
  (1, 64, 2, 5),
  (1, 692, 1, 5),
  (1, 389, 1, 2),
  (2, 570, 2, 1),
  (2, 631, 10, 2),
  (2, 43, 8, 4),
  (2, 70, 8, 4),
  (3, 776, 1.5, 1),
  (3, 777, 0.5, 1),
  (3, 364, 0.5, 1),
  (3, 750, 4, 1),
  (3, 778, 1, 2),
  (3, 595, 1, 3),
  (3, 366, 1, NULL);
  

  -- User Significant Recipe
INSERT INTO
  user_significant_recipe(user_id, recipe_id, recipe_significance_type_id)
VALUES
  (1, 1, 1),
  (2, 1, 2);