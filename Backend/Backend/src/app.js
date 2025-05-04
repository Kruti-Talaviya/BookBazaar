const express = require('express');
const mongoose = require('mongoose');
require('dotenv').config({path:'../.env'});
const PORT = process.env.PORT || 3000;
const MONGO_URI = process.env.MONGO_URI;
require("./db/db"); 
const userRoutes = require('./routes/userRoutes');
const bookRoutes = require('./routes/bookRoutes.js');
const path = require('path'); 
const cors = require('cors');
const bodyParser = require('body-parser');


const app = express();
mongoose.connect(MONGO_URI)
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.log('MongoDB connection error:', err));
app.use(express.json());
app.use(cors());
app.use(bodyParser.json());
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

app.use('/', userRoutes);
app.use('/book', bookRoutes);


app.listen(PORT,'0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
});
