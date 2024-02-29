// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: false },
  runtimeConfig: {
    // Variables here are server-side only by default and won't be exposed to the client
    redisHost: process.env.REDIS_HOST,
    redisPort: process.env.REDIS_PORT,
    redisPassword: process.env.REDIS_PASSWORD,
    redisUser: process.env.REDIS_USER, // Optional, depending on your Redis setup.
    // If you have variables that need to be available on both client and server, you can add them under public
    public: {
      // Example: apiBaseUrl: process.env.API_BASE_URL,
    },
  }
})