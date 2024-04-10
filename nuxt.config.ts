// https://nuxt.com/docs/api/configuration/nuxt-config
console.log('nuxt.config.ts______' + process.env.REDIS_URL);
export default defineNuxtConfig({
  runtimeConfig: {
    redisUrl: process.env.REDIS_URL, // Optional, depending on your Redis setup.
    // If you have variables that need to be available on both client and server, you can add them under public
    public: {
      // Example: apiBaseUrl: process.env.API_BASE_URL,
    },
  }
})