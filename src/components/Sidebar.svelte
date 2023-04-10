<script>
    import { writable } from 'svelte/store';
  
    export let position;
    export let defaultOpen = false;
    const open = writable(defaultOpen);
  
    function toggle() {
      open.update(o => !o);
    }
  </script>
  
  <div class="fixed top-0 bottom-0 z-50" class:sidebar-open={open} class:position={position}>
    <div class="flex flex-col h-full bg-gray-100" onclick|self={toggle}>
      <div class="flex items-center justify-between p-4 bg-gray-200">
        <h1 class="text-lg font-bold">{position === "left" ? "Left" : "Right"} Sidebar</h1>
        <button class="p-2" on:click|stopPropagation={toggle}>
          <svg class="w-6 h-6 fill-current" viewBox="0 0 24 24">
            <path d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
      <div class="flex-1 p-4 overflow-auto">
        <slot />
      </div>
    </div>
  </div>
  
  <style>
    .sidebar-open {
      transform: translateX(0);
    }
  
    .left {
      left: 0;
      transform: translateX(-100%);
    }
  
    .right {
      right: 0;
      transform: translateX(100%);
    }
  
    .sidebar-open.left {
      transform: translateX(0);
    }
  
    .sidebar-open.right {
      transform: translateX(0);
    }
  
    svg {
      stroke: currentColor;
      fill: none;
      stroke-width: 2;
      stroke-linecap: round;
      stroke-linejoin: round;
    }
  </style>  