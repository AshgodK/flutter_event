import { Router } from 'express';
import Event from '../models/Event.js';

import fs from 'fs';
import path from 'path';
import multer from'multer';
import bodyParser from 'body-parser';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { v4 as uuidv4 } from 'uuid';
const router = Router();
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);



const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // Set the destination folder for uploaded images
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = uuidv4();
    const fileExtension = path.extname(file.originalname);
    cb(null, `${file.fieldname}-${uniqueSuffix}${fileExtension}`);
  },
});

const upload = multer({ limits: { fieldSize: 20 * 1024 * 1024 } });

router.post('/add-event', upload.single('image'), async (req, res) => {
    try {
        // Validate request payload
        const { organizer, location, date, title, description } = req.body;

        if (!organizer || !location || !date || !title) {
            return res.status(400).json({ message: 'Missing required fields' });
        }

        // Get the uploaded file from req.file
        const imagePath = req.file ? req.file.path : '';
        console.log(imagePath);
        // Create a new Event instance with the custom image path
        const newEvent = new Event({
            organizer,
            location,
            date,
            title,
            description,
            image: req.body.image,
            // Other optional fields...
        });

        // Save the newEvent to the database
        await newEvent.save();

        // Respond with success message and data
        res.status(200).json({ message: 'Event added successfully', data: newEvent });
    } catch (error) {
        // Handle errors
        console.error(error);

        // Check if the error is a validation error
        if (error.name === 'ValidationError') {
            const validationErrors = Object.values(error.errors).map((e) => e.message);
            res.status(400).json({ message: 'Validation failed', errors: validationErrors });
        } else {
            res.status(500).json({ message: 'Internal server error' });
        }
    }
});


router.post('/add-eventdd', async (req, res) => {
    try {
        console.log('Received payload:', req.body.image)
        // Validate request payload
        const { organizer, location, date, title,description,image} = req.body;
        console.log('Received payload:', image)

        if (!organizer || !location || !date || !title) {
            return res.status(400).json({ message: 'Missing required fields' });
        }
        const imagePath = req.body.image;
        const customPath = join(__dirname, 'custom-images', `${Date.now()}_${path.basename(imagePath)}`);

        // Copy the image to the custom path
        fs.copyFileSync(imagePath, customPath);

        // Create a new Event instance
        const newEvent = new Event({
            organizer,
            location,
            date,
            title,
            description,
            image:customPath,
            // Other optional fields...
        });

        // Save the newEvent to the database
        await newEvent.save();

        // Respond with success message and data
        if(res.status(200))
        {
            console.log("status 200 successfull");
        }
        res.status(200).json({ message: 'Event added successfully', data: newEvent });
    } catch (error) {
        // Handle errors
        console.error(error);

        // Check if the error is a validation error
        if (error.name === 'ValidationError') {
            const validationErrors = Object.values(error.errors).map((e) => e.message);
            res.status(400).json({ message: 'Validation failed', errors: validationErrors });
        } else {
            res.status(500).json({ message: 'Internal server error' });
        }
    }
});

router.get('/get-all-events', async (req, res) => {
    console.log("get-event-test 1");
    try {
        console.log("get-event-test try block");
        const events = await Event.find();
console.log("get-event-test 2");
        res.json(events);
        //console.log(events);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});

router.post('/edit-event', async function (req, res) {
    try {
        const result = await Event.findOneAndUpdate(
            { _id: req.body.eventId },
            req.body.payload,
            { new: true } // This option returns the updated document
        );

        if (!result) {
            return res.status(404).json({ message: 'Event not found' });
        }

        res.json({ message: 'Event updated successfully', data: result });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
});


router.post('/delete-event', async function (req, res) {
    console.log("eventid");
    console.log(req.body.eventId);
    try {
        const eventId = req.body.eventId;

        if (!eventId) {
            return res.status(400).json({ message: 'Event ID is required for deletion' });
        }
        console.log(eventId);

        await Event.findOneAndDelete({ _id: eventId });

        res.send('Deleted');
    } catch (error) {
        console.error(error);
        res.status(500).json(error);
    }
});
router.post('/delete-all-events', async function (req, res) {
    try {
        // Perform deletion of all events
        await Event.deleteMany({});

        res.send('All events deleted');
    } catch (error) {
        console.error(error);
        res.status(500).json(error);
    }
});

export default router;