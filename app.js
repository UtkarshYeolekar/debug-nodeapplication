const currentTier = process.env.TIER;
console.log("current Tier  "+ currentTier);

if(currentTier === "redis")
   console.log('in redis');
else if(currentTier === 'bm')
    console.log("in bm");
else if (currentTier === "engine")
         server = require('./src/server.js');  