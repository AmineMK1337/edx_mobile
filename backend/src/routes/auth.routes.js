const express = require("express");
const router = express.Router();
const authController = require("../controllers/auth.controller");
const authMiddleware = require("../middlewares/auth");

router.post("/register", authController.register);
router.post("/login", authController.login);
router.get("/profile", authMiddleware.authenticate, authController.getProfile);

module.exports = router;
