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
	import '../styles/app.css'

	function drawerClose(): void {
		drawerStore.close();
	}

	function toggleSidebar(side: string) {
		if (side === "left") {
			classesSidebarLeft = classesSidebarLeft.includes("w-0") ? "w-64" : "w-0";
		} else if (side === "right") {
			classesSidebarRight = classesSidebarRight.includes("w-0") ? "w-64" : "w-0";
		}
	}

	// Reactive Properties
	$: classesSidebarLeft = $page.url.pathname === '/' ? 'w-0' : 'w-64 lg:w-64';
	$: classesSidebarRight = $page.url.pathname === '/' ? 'w-0' : 'w-0 lg:w-0';
	$: classesSidebarRight = $page.url.pathname === '/desk' ? 'w-0' : 'w-0 lg:w-0';
	$: classesSidebarRight = $page.url.pathname === '/chat' ? 'w-0' : 'w-0 lg:w-0';
	$: classesSidebarRight = $page.url.pathname === '/inbox' ? 'w-0' : 'w-0 lg:w-0';
	$: classesSidebarRight = $page.url.pathname === '/games' ? 'w-0' : 'w-0 lg:w-0';

</script>

<!-- App Shell -->
<AppShell slotSidebarLeft="bg-surface-500/5 {classesSidebarLeft}" slotSidebarRight="bg-surface-500/5 {classesSidebarRight}">
	<svelte:fragment slot="header">
	  <!-- App Bar -->
	  <AppBar>
		<svelte:fragment slot="lead">
		  <div class="flex items-center">
			<button class="lg: btn btn-sm mr-4" on:click={() => toggleSidebar("left")}> <!--class="hidden" //-->
				<span>
				<svg viewBox="0 0 100 80" class="fill-token w-4 h-4">
				  <rect width="100" height="20" />
				  <rect y="30" width="100" height="20" />
				  <rect y="60" width="100" height="20" />
				</svg>
			  </span>
			</button>
			<strong class="text-xl uppercase">Lucida</strong>
		  </div>
		</svelte:fragment>
		<svelte:fragment slot="trail">
		  <button class="btn btn-sm" on:click={() => toggleSidebar("right")}>
			<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-chevron-left" width="24" height="24" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
			  <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
			  <polyline points="15 6 9 12 15 18" />
			</svg>
		  </button>
		  
		</svelte:fragment>
	  </AppBar>
	</svelte:fragment>
	<!-- Left Sidebar Slot -->
	<svelte:fragment slot="sidebarLeft">
	  <Navigation />
	</svelte:fragment>
	<!-- Right Sidebar Slot -->
	<svelte:fragment slot="sidebarRight">
	  <Navigation />
	</svelte:fragment>
	<!-- Page Route Content -->
	<slot />
	<!-- Footer -->
<!--
	<svelte:fragment slot="footer">
	<div class="px-4 py-2">
		<p>Footer</p>		

	<nav class="list-nav p-4">
		<ul>
			<li><a href="/mypage">Min side</a></li>
			<li><a href="/logout">Logg ut</a></li>
		</ul>
	</nav>
	</svelte:fragment>
-->
	</AppShell>

	<style>
		.sidebar-transition {
		  transition: width 0.3s ease-in-out;
		}
	  
		.footer-transition {
		  transition: height 0.3s ease-in-out;
		}
	  
		.sidebar-closed {
		  width: 0;
		}
	  
		.sidebar-open {
		  width: 16rem; /* Adjust according to your design */
		}
	  
		.footer-closed {
		  height: 0;
		}
	  
		.footer-open {
		  height: 5rem; /* Adjust according to your design */
		}
	  </style>