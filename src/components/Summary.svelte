<script>
    import { messages, isProcessing, summary } from '../stores.js';
    let selectedFile;
    let apiKey = import.meta.env.VITE_OPENAI_API_KEY;

    function handleFileChange(event) {
        selectedFile = event.target.files[0];
        if (selectedFile) {
            summarizeFile(selectedFile);
        }
    }

    async function summarizeFile(file) {
        isProcessing.set(true);
        const text = await readFile(file);
        const summaryText = await getSummary(text);
        
        if (summaryText) {
            messages.update(currentMessages => {
                return [...currentMessages, {role: "system", content: `Her er et sammendrag av teksten du lastet opp: ${summaryText}`}];
            });
        }
        summary.set(summaryText);
        isProcessing.set(false);
    }

    function readFile(file) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onload = () => resolve(reader.result);
            reader.onerror = reject;
            reader.readAsText(file);
        });
    }

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
            return null; // Return null if there is an error
        }
    }
</script>

<div>
    <input type="file" accept=".txt, .html, .pdf, docx" on:change={handleFileChange} />
    {#if $isProcessing}
        <p>Jobber...</p>
    {:else}
        {#each $messages as message}
            {#if message.role === 'system'}
                <div class="summary">
                    <p>{message.content}</p>
                </div>
            {/if}
        {/each}
    {/if}
</div>
