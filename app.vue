<template>
  <div>
    <h1>Version 1</h1>
    <h2>You Visited this page {{ counter }} times</h2>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const counter = ref(0);

async function fetchCounter() {
  console.log('Before fetch call');
  try {
    const response = await fetch(`/api/redis-test?_=${new Date().getTime()}`);
    if (!response.ok) {
      throw new Error(`API call failed with status: ${response.status}`);
    }
    const data = await response.json();
    counter.value = data.counter;
  } catch (error) {
    console.error('Fetch error:', error);
  }
  console.log('After fetch call, counter is:', counter.value);
}

onMounted(async () => {
  await fetchCounter();
});

</script>
