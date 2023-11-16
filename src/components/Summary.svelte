<script>
    import { onMount } from 'svelte';
    import { messages } from '../stores.js';

    let selectedFile;
    let summary = '';
    let isProcessing = false;
    let apiKey = import.meta.env.VITE_OPENAI_API_KEY;

    // Function to handle file selection
    function handleFileChange(event) {
        selectedFile = event.target.files[0];
        if (selectedFile) {
            summarizeFile(selectedFile);
        }
    }

    // Function to read and summarize the file
    async function summarizeFile(file) {
        isProcessing = true;
        const text = await readFile(file);
        summary = await getSummary(text);
        messages.update(currentMessages => {
            return [...currentMessages, {role: "system", content: `Summary: ${summary}`}];
        });
        // messages = [...messages, {role: "system", content: `Summary: ${summary}`}];
        isProcessing = false;
    }

    // Function to read the file
    function readFile(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result);
            reader.onerror = reject;
            reader.readAsText(file);
        });
    }

    // Function to get summary from GPT (needs implementation)
    async function getSummary(textToSummarize) {
        const endpoint = "https://api.openai.com/v1/chat/completions";
        const body = {
            model: "gpt-3.5-turbo",
            messages: [
                {
                    role: "system",
                    content: "Du er en hjelpsom, norsk skole-assistent for en ti år gammel elev. Du heter Lucy, og avataren din en en søt og leken katt. Prøv å holde samtalen gående til enhver tid, og engasjer og motiver brukeren."
                },
                {
                    role: "user",
                    content: `Den ti år gamle eleven som du snakker med (på norsk), trenger et sammendrag av denne teksten. Trekk frem de viktigste tingene, og forklart kort hvorfor de er viktige.: ${textToSummarize}`
                }
            ]
        };

        try {
            const response = await fetch(endpoint, {
                method: "POST",
                headers: {
                    "Authorization": `Bearer ${apiKey}`,
                    "Content-Type": "application/json",
                    'language': 'no'
                },
                body: JSON.stringify(body)
            });

            const data = await response.json();
            return data.choices[0].message.content.trim();
        } catch (error) {
            console.error("Error in summarization:", error);
            return "An error occurred while summarizing.";
        }
}
</script>

<div>
    <input type="file" accept=".txt, .html" on:change={handleFileChange} />
    {#if isProcessing}
        <p>Processing...</p>
    {:else}
        {#if summary}
            <div class="summary">
                <p>{summary}</p>
            </div>
        {/if}
    {/if}
</div>
