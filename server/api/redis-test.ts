// server/api/redis-test.ts
import { defineEventHandler } from 'h3';
import Redis from 'ioredis';

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig();

  const redis = new Redis(config.redisUrl);

  const key = 'counter';
  const newCounterValue = await redis.incr(key);

  return new Response(JSON.stringify({ counter: newCounterValue }), {
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-store'
    },
  });
});
