'use strict';

const express = require('express');

function main() {
  const app = express();

  app.get('/', (req, res) => {
    res.json({
      message: 'I am up!',
      now    : Date.now(),
      version: process.version
    });
  });

  app.listen(process.env.PORT || 80)
}

main();
