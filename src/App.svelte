<script>
  import { Router } from '@sveltejs/kit';
  import { routes } from './routes';
  import { writable } from 'svelte/store';
  import './global.css';
  // import './styles/app.css';

  const leftMenuOpen = writable(false);
  const rightMenuOpen = writable(false);

  function toggleMenu() {
    leftMenuOpen.update(value => !value);
  }

</script>

<header>
  <nav class="bg-gray-300 py-4">
    <div class="flex items-center justify-between px-4">
      <h1 class="text-lg font-bold">Top menu</h1>
      <div class="flex items-center">
        <button class="mr-2" on:click={toggleMenu}>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h8m-8 6h16" />
          </svg>
        </button>
        <button on:click={toggleMenu}>
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h8m-8 6h16" />
          </svg>
        </button>
      </div>
    </div>
  </nav>
</header>

<div class="flex h-screen w-full">
  <div class="w-0 transition-all duration-300 ease-in-out" class:menu-open={$leftMenuOpen}>
    <Sidebar position="left" onToggle={toggleMenu} />
  </div>

  <div class="flex-1 bg-white p-4">
    <h1>Page Content</h1>
  </div>

  <div class="w-0 transition-all duration-300 ease-in-out" class:menu-open={$rightMenuOpen}>
    <Sidebar position="right" onToggle={toggleMenu} />
  </div>
</div>

<style>
  .menu-open {
    width: 250px;
  }

  button {
    border: none;
    background-color: transparent;
    cursor: pointer;
  }

  button:hover svg {
    stroke: #fff;
  }

  button svg {
    stroke: #000;
    height: 1.5rem;
    width: 1.5rem;
    transition: stroke 0.2s ease;
  }

  /* Styling for sidebar */
  .sidebar {
    height: 100%;
    background-color: #f1f1f1;
    padding: 1rem;
  }

  .sidebar h2 {
    font-size: 1.5rem;
    font-weight: bold;
    margin-bottom: 1rem;
  }
</style>
