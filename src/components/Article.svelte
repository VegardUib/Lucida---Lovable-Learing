<script>
  import { onMount, onDestroy, afterUpdate } from 'svelte';
  let isSSR = import.meta.env.SSR;
  let articleContent = '';

  onMount(async () => {
    if (isSSR) return;
    // Fetch the article content here and set it to the articleContent variable
    articleContent = '<div><h1>Title</h1><p>Pretium cum vestibulum at vulputate justo platea ante dis. Congue sem dictum per sit elit habitasse ad sem pretium. Ad ac enim proin tempus duis imperdiet eget. Quis ornare, scelerisque ullamcorper per curae; proin diam. Vehicula vel egestas quis dolor maecenas iaculis turpis ad felis ligula tempor? Volutpat ac, sapien habitasse ornare. Adipiscing lobortis suscipit arcu sagittis cum consectetur. Cubilia, gravida sed magnis class tempor erat accumsan. Sem cursus vel sed tempus, per ligula. Consequat scelerisque adipiscing mollis fermentum duis bibendum. Habitant ante euismod, montes fringilla vivamus.</p><p>Duis velit molestie arcu parturient ultricies tortor. Magnis praesent in vehicula risus velit, sed lobortis justo donec cras laoreet parturient. Morbi taciti parturient facilisi a ultricies pulvinar curae; pretium. Tellus dis laoreet curae; per posuere suspendisse torquent pharetra eros purus nascetur. Nisl iaculis aenean aenean dui dignissim. Nec urna tincidunt aliquam id dui condimentum sodales vel tincidunt consequat amet magna. Mollis duis, mollis ad nec vivamus varius luctus odio quisque sociis fames torquent. Felis fusce; conubia potenti lacus dolor? Et mauris luctus aliquam sed tortor. Elementum.</p><h2>Subtitle</h2><p>Posuere morbi mus, gravida id lacinia sociosqu nam pretium convallis orci purus. Congue proin interdum dolor iaculis hendrerit natoque mi. Elit adipiscing tempor tellus quisque magna ligula. Aliquet et molestie luctus dictumst aliquam vulputate. Scelerisque placerat, ac id tempus. Aenean ut platea primis mollis risus nunc lobortis nisl magnis nisl purus rutrum.</p><h3>Subsub-title</h3><p>Diam morbi vulputate ligula elit est cras per lorem inceptos pellentesque. Vel nascetur egestas, proin suspendisse porta tortor eleifend urna litora ut? Facilisis pretium elit tempor molestie litora, duis vestibulum ac sapien scelerisque nostra. Lobortis dapibus velit sem bibendum suspendisse iaculis at ad quisque nascetur? Faucibus velit imperdiet porttitor pulvinar platea venenatis ut in bibendum magna feugiat aenean. Eleifend laoreet non sociis ad semper. Consectetur senectus dolor adipiscing malesuada maecenas ridiculus erat magnis volutpat. Ipsum diam eros sed iaculis lobortis fringilla pharetra ornare cum.</p><p>Elit est lacinia scelerisque mollis turpis sed sollicitudin platea gravida arcu pharetra aliquet. Tristique sodales aliquam mattis integer arcu vulputate. Orci facilisis senectus elit dictumst eros blandit cum torquent lectus habitasse taciti. Eleifend laoreet, massa natoque magnis habitasse etiam consectetur et ridiculus proin litora. Nam aenean lobortis porta dictum pharetra, montes gravida malesuada ornare magna netus a! Vel porttitor cras lorem neque viverra. Mus conubia curae; magna. Porta ut dignissim mollis nec viverra donec commodo enim semper bibendum taciti quam! Montes iaculis rutrum ipsum urna ornare ante non. Venenatis!</p></div>'; 
    // Replace with actual content
  });

  let article = '';

  function updateVariables() {
    if (!article) return;

    const { width, height } = article.getBoundingClientRect();
    const fontSize = Math.min(width / 30, height / 45); // Adjust the divisor to control the font size
    const lineHeight = fontSize * 1.6;

    document.documentElement.style.setProperty('--base-font-size', `${fontSize}px`);
    document.documentElement.style.setProperty('--base-line-height', `${lineHeight}px`);
  }

  onMount(() => {
    if (isSSR) return;

    updateVariables();
    window.addEventListener('resize', updateVariables);
  });

  afterUpdate(() => {
    if (isSSR) return;

    updateVariables();
  });

  onDestroy(() => {
    if (isSSR) return;

    window.removeEventListener('resize', updateVariables);
  });
</script>

<article id="artikkeltest" class="prose max-w-none" bind:this={article}>
  {@html articleContent}
</article>
<style>
  :global(article.prose.max-w-none) {

    /* Set the top and bottom margins using the golden ratio */
    padding-top: calc(2rem * 1.618);
    padding-bottom: calc(2rem * 1.618);

    /* Set the left and right margins to center the article within the viewport */
    padding-left: calc(33%/2);
    padding-right: calc(33%/2);
  }
</style>