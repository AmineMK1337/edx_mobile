const mongoose = require("mongoose");

const SchoolInfoSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      default: "SUP'COM"
    },
    fullName: {
      type: String,
      default: "École Supérieure des Communications de Tunis"
    },
    presentation: {
      type: String,
      required: true
    },
    studentsCount: {
      type: String,
      default: "1200+"
    },
    teachersCount: {
      type: String,
      default: "90+"
    },
    partnersCount: {
      type: String,
      default: "30+"
    },
    labsCount: {
      type: String,
      default: "15"
    },
    departments: [{
      type: String
    }],
    address: {
      type: String,
      required: true
    },
    phone: {
      type: String,
      required: true
    },
    email: {
      type: String,
      default: ""
    },
    website: {
      type: String,
      required: true
    },
    logoUrl: {
      type: String,
      default: ""
    },
    imageUrl: {
      type: String,
      default: ""
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("SchoolInfo", SchoolInfoSchema);
