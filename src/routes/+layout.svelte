<script lang="ts">
	import { page } from '$app/stores';

	// Skeleton Features
	import { AppShell, AppBar } from '@skeletonlabs/skeleton';
	import { Drawer, drawerStore } from '@skeletonlabs/skeleton';

	// Local Features
	import Navigation from '$lib/Navigation/Navigation.svelte';

	// Stylesheets
	import '@skeletonlabs/skeleton/themes/theme-skeleton.css';
	import '@skeletonlabs/skeleton/styles/all.css';
	import '../app.postcss';

	function drawerOpen(): void {
		drawerStore.open({});
	}

	// Reactive Properties
	$: classesSidebarLeft = $page.url.pathname === '/' ? 'w-0' : 'w-0 lg:w-64';
</script>
<!-- App Shell -->
<!-- App Shell -->
<AppShell slotSidebarLeft="bg-surface-500/5 {classesSidebarLeft}" slotSidebarRight="bg-surface-500/5 w-0 md:w-64">
	<svelte:fragment slot="header">
	  <!-- Drawer -->
	  <Drawer>
		<h2 class="p-4">Navigation</h2>
		<hr />
		<Navigation />
	  </Drawer>    
	  <!-- App Bar -->
	  <AppBar>
		<svelte:fragment slot="lead">
		  <div class="flex items-center">
			<button class="lg:hidden btn btn-sm mr-4" on:click={drawerOpen}>
			  <span>
				<svg viewBox="0 0 100 80" class="fill-token w-4 h-4">
				  <rect width="100" height="20" />
				  <rect y="30" width="100" height="20" />
				  <rect y="60" width="100" height="20" />
				</svg>
			  </span>
			</button>
			<strong class="text-xl uppercase">Skeleton</strong>
		  </div>
		</svelte:fragment>
		<svelte:fragment slot="trail">
		  <a class="btn btn-sm" href="/">Home</a>
		  <a class="btn btn-sm" href="/about">About</a>
		</svelte:fragment>
	  </AppBar>
	</svelte:fragment>
	<!-- Left Sidebar Slot -->
	<svelte:fragment slot="sidebarLeft">
	  <Navigation />
	</svelte:fragment>
	<!-- Right Sidebar Slot -->
	<svelte:fragment slot="sidebarRight">
	  <h2 class="p-4">Right Sidebar</h2>
	</svelte:fragment>
	<!-- Page Route Content -->
	<slot />
	<!-- Footer -->
	<svelte:fragment slot="footer">
	  <h2 class="p-4">Footer</h2>
	</svelte:fragment>
  </AppShell>
  