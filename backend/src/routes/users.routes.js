const express = require("express");
const router = express.Router();
const { authenticate } = require("../middlewares/auth");
const usersController = require("../controllers/users.controller");

router.get("/", authenticate, usersController.getUsers);
router.get("/students", authenticate, usersController.getStudents);
router.get("/class/:className", authenticate, usersController.getUsersByClass);

module.exports = router;
