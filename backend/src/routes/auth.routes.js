const express = require("express");
const router = express.Router();
const authController = require("../controllers/auth.controller");
const authMiddleware = require("../middlewares/auth");

// Auth routes
router.post("/register", authController.register);
router.post("/login", authController.login);
router.get("/profile", authMiddleware.authenticate, authController.getProfile);

// Password reset routes
router.post("/forgot-password", authController.forgotPassword);
router.post("/verify-reset-code", authController.verifyResetCode);
router.post("/reset-password", authController.resetPassword);

module.exports = router;
