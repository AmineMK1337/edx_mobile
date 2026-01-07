const adminAuth = (req, res, next) => {
  if (req.userRole !== 'admin' && req.userRole !== 'administrateur') {
    return res.status(403).json({ error: "Admin access required" });
  }
  next();
};

module.exports = { adminAuth };