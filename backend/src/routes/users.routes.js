const express = require("express");
const router = express.Router();
const usersController = require("../controllers/users.controller");

router.get("/", usersController.getUsers);
router.get("/students", usersController.getStudents);
router.get("/class/:className", usersController.getUsersByClass);

module.exports = router;
