<!-- LeftMenu.svelte -->
<script>
    export let position = "left";
  </script>
  
  <p>{position === "left" ? "Left" : "Right"} Menu</p>