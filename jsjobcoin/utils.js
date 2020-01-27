#!/usr/bin/env node
"use strict";
const crypto = require("crypto");

const utils = {
  generateDepositAddress() { // this is creating the deposit address that the mixer owns
    const hash = crypto.createHash("sha256");
    return hash
      .update(`${Date.now()}`)
      .digest("hex")
      .substring(0, 8);
  }
};

module.exports = utils;
