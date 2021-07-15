<template>
  <div>
   <b-navbar
      toggleable="lg"
      type="dark"
      variant="info"
      style="background-color: #1675fd !important;"
    >
    <b-navbar-brand>Cloud Native Starter select</b-navbar-brand>
    </b-navbar>
    <Tenant />
  </div>
</template>

<script>
import Tenant from './components/Tenant.vue'

export default {
  name: 'App',
  components: {
    Tenant
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
