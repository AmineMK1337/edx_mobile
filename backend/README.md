# Backend Server

Node.js/Express backend server for my_app.

## Setup

```bash
cd backend
npm install

# copy env and configure Mongo URI / port
cp .env.example .env
npm run dev
```

Environment variables:

- `PORT` (default 3000)
- `MONGO_URI` (e.g., `mongodb://127.0.0.1:27017/my_app`)

## Project Structure

```
backend/
├── src/
│   ├── server.js
│   ├── config/
│   ├── controllers/
│   ├── middlewares/
│   ├── models/
│   ├── routes/
│   ├── services/
│   └── utils/
├── package.json
└── README.md
```

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/exams` - List exams
- `POST /api/exams` - Create exam (expects body fields: title, subject, status, date, time, className, studentCount, duration, location)
- `GET /api/events` - List calendar events
- `POST /api/events` - Create event (fields: title, type, date, time, location, group)
