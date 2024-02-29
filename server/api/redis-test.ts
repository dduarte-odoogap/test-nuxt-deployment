// server/api/redis-test.ts
import { defineEventHandler } from 'h3';
import Redis from 'ioredis';

export default defineEventHandler(async (event) => {
  const config = useRuntimeConfig();
  console.log(':::::::::::::::::::::::: ' + config.redisHost);
  console.dir(config);

  const redis = new Redis({
    host: config.redisHost as string,
    port: +config.redisPort as number,
    password: config.redisPassword as string,
    username: config.redisUser as string,
    tls: {}
  });

  const key = 'counter';
  const newCounterValue = await redis.incr(key);

  return new Response(JSON.stringify({ counter: newCounterValue }), {
    headers: {
      'Content-Type': 'application/json',
    },
  });
});
