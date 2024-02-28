// server/redis-test.ts
import { defineEventHandler } from 'h3';
import Redis from 'ioredis';

const redis = new Redis({
  host: 'test-nuxt-9urcxn.serverless.euc1.cache.amazonaws.com', // or your Redis server host
  port: 6379, // default Redis port
  // password: 'yourpassword', if your Redis instance is secured
});

export default defineEventHandler(async (event) => {
  const key = 'counter';
  const newCounterValue = await redis.incr(key);
  return new Response(JSON.stringify({ counter: newCounterValue }), {
    headers: {
      'Content-Type': 'application/json',
    },
  });
});
