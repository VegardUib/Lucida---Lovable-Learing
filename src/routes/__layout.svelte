<script>
  import { AppShell } from '@skeletonlabs/skeleton';

  export let pageContext;
  export let segments;

  // These variables are passed from the page to the app-shell, to control the content of the shell's slots
  export let pageTitle;
  export let pageHeaderContent;
  export let pageContent;
  export let pageFooterContent;

  // Define the layout of the app
  <AppShell>
    <svelte:fragment slot="header">{pageHeaderContent}</svelte:fragment>
    <svelte:fragment slot="sidebarLeft">Sidebar Left</svelte:fragment>
    <svelte:fragment slot="sidebarRight">Sidebar Right</svelte:fragment>
    <svelte:fragment slot="pageHeader">
      <h1>{pageTitle}</h1>
    </svelte:fragment>
    <svelte:fragment slot="pageContent">{pageContent}</svelte:fragment>
    <svelte:fragment slot="pageFooter">{pageFooterContent}</svelte:fragment>
    <svelte:fragment slot="footer">Footer</svelte:fragment>
  </AppShell>
</script>

<div slot="pageContent">
  <slot />
</div>


<style>
</style>