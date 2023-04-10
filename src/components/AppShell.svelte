<script lang="ts">
  import { Component } from 'svelte';
</script>

<Component>
  <svelte:fragment slot="header" />
  <svelte:fragment slot="sidebarLeft" />
  <svelte:fragment slot="sidebarRight" />
  <svelte:fragment slot="pageHeader" />
  <slot />
  <svelte:fragment slot="pageFooter" />
  <svelte:fragment slot="footer" />
</Component>
