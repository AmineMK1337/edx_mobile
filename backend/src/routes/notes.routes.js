const express = require("express");
const router = express.Router();
const { authenticate } = require("../middlewares/auth");
const notesController = require("../controllers/notes.controller");

router.get("/", authenticate, notesController.getNotes);
router.post("/", authenticate, notesController.createNote);
router.put("/:id", authenticate, notesController.updateNote);
router.delete("/:id", authenticate, notesController.deleteNote);

module.exports = router;
