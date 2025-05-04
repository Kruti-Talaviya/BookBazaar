const express = require('express');
const router = express.Router();
const bookController = require('../controllers/bookController');
const multer = require('multer');



const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // Set the upload directory
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname); 
  }
});

const upload = multer({ storage: storage });
router.post('/', upload.single('photo'), bookController.addBook);
router.put('/:bookId', upload.single('photo'), bookController.updateBook);
router.get('/get', bookController.getBooks);
router.get('/bookid/:bookId', bookController.getBookById);
router.get('/', bookController.getBookBycategory);
router.post('/purchase/:bookId', bookController.purchaseBook);
router.get('/buyer/:buyerId', bookController.getBooksByBuyerId);
router.delete('/:bookId', bookController.deleteBook);
router.get('/seller/:sellerId', bookController.findSoldBooksBySellerId);
module.exports = router;
