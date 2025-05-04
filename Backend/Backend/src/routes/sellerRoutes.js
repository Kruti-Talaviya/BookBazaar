const express = require('express');
const router = express.Router();
const sellerController = require('../controllers/sellerController');

const multer = require('multer');



const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/'); // Set the upload directory
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '_' + file.originalname); 
  }
});
const upload = multer({ storage: storage });


router.post('/',  upload.single('photo'),sellerController.addSeller);
router.get('/get', sellerController.getallSeller);
router.get('/', sellerController.getSellerByName);
router.get('/:userId',sellerController.getSellerbyid);
router.delete('/:userId',sellerController.deleteSeller);
router.put('/:userId', upload.single('photo'),sellerController.updateSeller);

module.exports = router;
