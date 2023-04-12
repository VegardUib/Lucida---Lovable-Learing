<script>
    import { onMount } from 'svelte';
    let articleContent;
  
    onMount(async () => {
      // Fetch the article content here and set it to the articleContent variable
      articleContent = 'Bare tester...'; // Replace with actual content
    });
  </script>
  
  <article class="prose max-w-none">
    {@html articleContent}
  </article>
  