#!/usr/bin/env node
"use strict";
const axios = require("axios");

/* Urls */
const API_BASE_URL = "http://jobcoin.gemini.com/pauper-jackpot/api";
const API_ADDRESS_URL = `${API_BASE_URL}/addresses/`;
const API_TRANSACTIONS_URL = `${API_BASE_URL}/transactions/`;
