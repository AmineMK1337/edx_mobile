const nodemailer = require("nodemailer");

// Create transporter for sending emails
const createTransporter = () => {
  // Check if email credentials are configured
  if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
    console.warn("⚠️ Email credentials not configured. Email sending will be simulated.");
    return null;
  }

  return nodemailer.createTransport({
    service: "gmail",
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });
};

const transporter = createTransporter();

// Send email function with fallback for development
const sendEmail = async (options) => {
  if (!transporter) {
    // Development mode - log email instead of sending
    console.log("📧 [DEV MODE] Email would be sent:");
    console.log(`   To: ${options.to}`);
    console.log(`   Subject: ${options.subject}`);
    console.log(`   Content: ${options.text || "HTML content"}`);
    return { messageId: "dev-mode-" + Date.now() };
  }

  try {
    const mailOptions = {
      from: `"SUPCOM Support" <${process.env.EMAIL_USER}>`,
      ...options,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log("📧 Email sent:", info.messageId);
    return info;
  } catch (error) {
    console.error("❌ Email sending failed:", error.message);
    throw error;
  }
};

// Send password reset code email
const sendPasswordResetEmail = async (email, resetCode) => {
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 20px; }
        .container { max-width: 500px; margin: 0 auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { text-align: center; color: #0F1C2E; }
        .code { font-size: 32px; letter-spacing: 8px; text-align: center; background: #E3F2FD; padding: 20px; border-radius: 8px; margin: 20px 0; color: #1976D2; font-weight: bold; }
        .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
        .warning { color: #E53935; font-size: 13px; }
      </style>
    </head>
    <body>
      <div class="container">
        <h2 class="header">🔐 Réinitialisation du mot de passe</h2>
        <p>Bonjour,</p>
        <p>Vous avez demandé la réinitialisation de votre mot de passe. Voici votre code de vérification :</p>
        <div class="code">${resetCode}</div>
        <p class="warning">⏱️ Ce code expire dans <strong>15 minutes</strong>.</p>
        <p>Si vous n'avez pas demandé cette réinitialisation, ignorez simplement cet email.</p>
        <div class="footer">
          <p>SUPCOM © 2017-2025</p>
          <p>Cet email a été envoyé automatiquement, merci de ne pas y répondre.</p>
        </div>
      </div>
    </body>
    </html>
  `;

  return sendEmail({
    to: email,
    subject: "Code de réinitialisation du mot de passe - SUPCOM",
    html,
    text: `Votre code de réinitialisation est: ${resetCode}. Ce code expire dans 15 minutes.`,
  });
};

module.exports = {
  transporter,
  sendEmail,
  sendPasswordResetEmail,
};
