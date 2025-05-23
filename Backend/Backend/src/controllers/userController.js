const bcrypt = require('bcrypt');
const User = require('../models/User');
const Seller = require('../models/Seller');
const Book = require('../models/Book');

exports.register = async (req, res) => { 
    try {
        const { username, email, password } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({
                status: false,  
                message: "User Already Exist"
              });
            }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = new User({
            username,
            email,
            password: hashedPassword
        });

        await newUser.save();

        res.status(201).json({
            status: true,
            message: "User registered successfully",
            user: newUser.toObject({ getters: true }) 
        });
    } catch (error) {
        if (error.code === 11000) {
            return res.status(400).json({ 
                status: true,
                message: "Username or email already exists" });
        }
        console.error("Error during registration:", error);
        res.status(500).json({ message: "Server error" });
    }
};


exports.login = async (req, res) => {
    try {
      const { email, password } = req.body;
  
      
      const user = await User.findOne({ email });
      if (!user) {
        return res.status(400).json({
            status: false,  
            message: "Invalid Email"
          });
      }
  
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(400).json({
            status: false,  
            message: "Invalid Password"
          });
      }
  
      let response = {
        message: "Login successful",
          status: true,
          id: user._id,
          email: user.email,
          username: user.username,
          isSeller: user.isSeller
        
      };
  
      
      if (user.isSeller) {
        const seller = await Seller.findOne({ user: user._id });
        if (seller) {
          response.sellerId = seller._id; 
        }
      }
  
      res.json(response);
    } catch (error) {
      console.error("Error during login:", error);
      res.status(500).json({ message: "Server error" });
    }
  };
  
exports.updateUser = async (req, res) => {
    try {
        const { userId } = req.params;
        const updatedData = req.body;

        if (updatedData.password) {
           
            const hashedPassword = await bcrypt.hash(updatedData.password, 10);
            updatedData.password = hashedPassword;
        }

      
        const updatedUser = await User.findByIdAndUpdate(userId, updatedData, { new: true });
        if (!updatedUser) {
            return res.status(400).json({
                status: false,  
                message: "User Not Found"
              });
        }

        res.json(updatedUser);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

exports.deleteUser = async (req, res) => {
    try {
        const user = await User.findById(req.params.userId);

        if (!user) {
            return res.status(400).json({
                status: false,  
                message: "User Not Found"
              });
        }

        const seller = await Seller.findOne({ user: req.params.userId });

        if (seller) {
            await Book.deleteMany({ seller: seller._id });

            await Seller.findByIdAndDelete(seller._id);

            await User.findByIdAndDelete(req.params.userId);

            return res.status(200).json({
                status: true,  
                message: 'User and their data deleted successfully'
              });
        } else {
            await User.findByIdAndDelete(req.params.userId);
            res.status(200).json({
                status: true,  
                message: 'User deleted successfully'
              });
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};
