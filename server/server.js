import express from 'express';
import json from 'express';
import bodyParser from 'body-parser';
import dbConnect from './dbConnect.js';
import cors from 'cors';

const app = express();
app.use(express.json({ limit: '10mb' })); // Adjust the limit as needed
app.use(express.urlencoded({ extended: true, limit: '10mb' })); // Adjust the limit as needed

app.use(cors());
app.use(json());
app.use(bodyParser.json());
app.use('/uploads', express.static('uploads'))
// Establish a database connection


import eventRoute from './routes/eventsRoute.js';

app.use('/api/events/', eventRoute);

const port = 5001;
app.get('/', (req, res) => res.send('Hello'));
app.listen(port, () => console.log(`app listening on port ${port}`));
