
const express = require('express');
const router = express.Router();
const sellerRoutes = require('../routes/sellerRoutes');
const userController = require('../controllers/userController');


router.post('/signup', userController.register);
router.post('/login', userController.login);
router.use('/seller',sellerRoutes);

// router.get('/', userController.getAllUsers); 
router.put('/:userId', userController.updateUser);
router.delete('/:userId',userController.deleteUser); 

module.exports = router;