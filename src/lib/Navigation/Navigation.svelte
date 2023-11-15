<script lang="ts">
	import { drawerStore } from '@skeletonlabs/skeleton';

	function drawerClose(): void {
		drawerStore.close();
	}
</script>

<nav class="list-nav p-4">
	<ul>
		<li><a href="/" on:click={drawerClose}>Hjem</a></li>
		<li><a href="/chat" on:click={drawerClose}>Snakk med Lucy</a></li>
		<li><a href="/desk" on:click={drawerClose}>Skrivebord</a></li>
		<li><a href="/inbox" on:click={drawerClose}>Beskjeder</a></li>
		<li><a href="/games" on:click={drawerClose}>Spill</a></li>
<!--		<li><a href="/mypage" on:click={drawerClose}>Min side</a></li> -->
	</ul>
</nav>
