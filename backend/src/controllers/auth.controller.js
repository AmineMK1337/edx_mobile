const User = require("../models/user");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const { sendPasswordResetEmail } = require("../utils/mailer");

// Generate 6-digit reset code
const generateResetCode = () => {
  return crypto.randomInt(100000, 999999).toString();
};

exports.register = async (req, res) => {
  try {
    const { name, email, password, role, class: className } = req.body;

    // Vérifier si l'utilisateur existe
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: "User already exists" });
    }

    // Hasher le mot de passe
    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({
      name,
      email,
      password: hashedPassword,
      role,
      class: className
    });

    await user.save();
    res.status(201).json({ message: "User registered successfully", user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log("Login attempt for:", email);

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ error: "Email ou mot de passe incorrect" });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ error: "Email ou mot de passe incorrect" });
    }

    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET || "secret_key",
      { expiresIn: "24h" }
    );

    res.json({
      message: "Login successful",
      token,
      user: { id: user._id, name: user.name, email: user.email, role: user.role }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getProfile = async (req, res) => {
  try {
    const user = await User.findById(req.userId).select("-password");
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// FORGOT PASSWORD - Send reset code
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;
    console.log("Forgot password request for:", email);

    if (!email) {
      return res.status(400).json({ message: "Email is required" });
    }

    const user = await User.findOne({ email });
    if (!user) {
      // For security, don't reveal if email exists or not
      return res.json({ message: "Si cet email existe, un code a été envoyé" });
    }

    // Generate and store reset code
    const resetCode = generateResetCode();
    user.resetCode = resetCode;
    user.resetCodeExpiration = Date.now() + 15 * 60 * 1000; // 15 minutes
    await user.save();

    console.log(`Reset code for ${email}: ${resetCode}`);

    // Send email
    try {
      await sendPasswordResetEmail(email, resetCode);
    } catch (emailError) {
      console.error("Email sending failed:", emailError.message);
      // Continue anyway - in dev mode, code is logged
    }

    res.json({ message: "Code de réinitialisation envoyé" });
  } catch (error) {
    console.error("Forgot password error:", error);
    res.status(500).json({ message: error.message });
  }
};

// VERIFY RESET CODE
exports.verifyResetCode = async (req, res) => {
  try {
    const { email, code } = req.body;
    console.log("Verifying code for:", email, "Code:", code);

    if (!email || !code) {
      return res.status(400).json({ message: "Email and code are required" });
    }

    const user = await User.findOne({
      email,
      resetCode: code.toString(),
      resetCodeExpiration: { $gt: Date.now() }
    });

    if (!user) {
      console.log("Invalid or expired code for:", email);
      return res.status(400).json({ message: "Code invalide ou expiré" });
    }

    console.log("Code verified successfully for:", email);
    res.json({ message: "Code vérifié avec succès" });
  } catch (error) {
    console.error("Verify code error:", error);
    res.status(500).json({ message: error.message });
  }
};

// RESET PASSWORD
exports.resetPassword = async (req, res) => {
  try {
    const { email, code, newPassword } = req.body;
    console.log("Reset password request for:", email);

    if (!email || !code || !newPassword) {
      return res.status(400).json({ message: "Email, code and new password are required" });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({ message: "Le mot de passe doit contenir au moins 6 caractères" });
    }

    const user = await User.findOne({
      email,
      resetCode: code.toString(),
      resetCodeExpiration: { $gt: Date.now() }
    });

    if (!user) {
      return res.status(400).json({ message: "Code invalide ou expiré" });
    }

    // Hash new password and clear reset code
    user.password = await bcrypt.hash(newPassword, 10);
    user.resetCode = null;
    user.resetCodeExpiration = null;
    await user.save();

    console.log("Password reset successful for:", email);
    res.json({ message: "Mot de passe réinitialisé avec succès" });
  } catch (error) {
    console.error("Reset password error:", error);
    res.status(500).json({ message: error.message });
  }
};
