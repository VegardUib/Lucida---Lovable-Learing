<script type="ts">
    import { onMount, afterUpdate } from 'svelte';
    // import type { MediaRecorder } from 'types/dom-mediacapture-record';

    let apiKey = import.meta.env.VITE_OPENAI_API_KEY;
    let conversationBox : any;
    let mediaRecorder : any;
    let audioChunks : any[] = [];

    function updateUserInputPlaceholder() {
        userInputPlaceholder = getRandomProcessingMessage();
    }

    onMount(async () => {
        updateUserInputPlaceholder();
        // Uncomment the following line if you want to request permissions on mount
        // but keep in mind this might not work as expected due to browser security restrictions.
        await navigator.mediaDevices.getUserMedia({ audio: true });
        window.addEventListener('keydown', handleKeyDown);
    });

    let userInputPlaceholder = "Du kan skrive her...";
    let processingMessages = ["Krøller data", "Kalkulerer fremtiden…", "Sender og mottar…", "Et par øyeblikk, bare", "2 sek…", "Funderer på svaret…"];
    let currentProcessingMessage = "";

    function getRandomProcessingMessage() {
        const randomIndex = Math.floor(Math.random() * processingMessages.length);
        return processingMessages[randomIndex];
    }

    
    let messages = [
        {role: "system", content: "Du er en hjelpsom, norsk skole-assistent for en ti år gammel elev. Du heter Lucy, og avataren din en en søt og leken katt. Prøv å holde samtalen gående til enhver tid, og engasjer og motiver brukeren."}
    ];

    let userInput = "";
    let systemMessage = messages[0].content;
    let isProcessing = false;  // Track if the request is in progress
    let isRecording = false; // Track if we are currently recording

    async function startRecording() {
        audioChunks = [];
        if (isRecording) return;
        isRecording = true;
        isProcessing = true;

        try {
            const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

            let options = {};
            // Check for browser support for the desired MIME type
            const desiredMimeType = 'audio/webm';
            if (MediaRecorder.isTypeSupported(desiredMimeType)) {
                options = { mimeType: desiredMimeType };
            } else {
                console.warn(`${desiredMimeType} is not supported on this browser. Using default MIME type.`);
            }

            mediaRecorder = new MediaRecorder(stream, options);

            mediaRecorder.ondataavailable = event => {
                console.log("Chunk data size: ", event.data.size);
                audioChunks.push(event.data);
            };

            mediaRecorder.onstop = async () => {
                const audioBlob = new Blob(audioChunks, { type: desiredMimeType });
                const audioBuffer = await audioBlob.arrayBuffer();
                sendToWhisper(audioBuffer);
                isRecording = false;
                userInputPlaceholder = getRandomProcessingMessage();
                stream.getTracks().forEach(track => track.stop());
            };

            mediaRecorder.start();
        } catch (error) {
            console.error('Error starting recording:', error);
        }
    }

    function stopRecording() {
        if (!mediaRecorder || mediaRecorder.state === 'inactive') {
            console.error('Recorder not initialized or already stopped.');
            return;
        }
        
        mediaRecorder.stop();

        
        // No need to change isRecording here; it will be set in the onstop handler
    }

    async function sendToWhisper(audioBuffer) {
        const WHISPER_ENDPOINT = "https://api.openai.com/v1/audio/transcriptions";
        userInputPlaceholder = getRandomProcessingMessage();
        isProcessing = true;
        
        try {
            const formData = new FormData();
            formData.append('model', 'whisper-1');
            formData.append('language', 'no');
            // formData.append('language', 'en');
            formData.append('file', new Blob([audioBuffer], { type: 'audio/wav' }));

            const response = await fetch(WHISPER_ENDPOINT, {
                method: 'POST',
                headers: {
                    "Authorization": `Bearer ${apiKey}`
                },
                body: formData
            });

            const data = await response.json();

            const transcribedText = data.text;
                        
            console.log("Whisper API response:", data, data.text);
            if (transcribedText && transcribedText.trim() !== "") {
                userInput = transcribedText;
                console.log("Transcribed Text:", transcribedText);
                isRecording = false;
                isProcessing = true;
                interactWithAI();
            } else {
                console.warn("User input is empty or undefined after transcription.");
            }
        } catch (error) {
            console.error('Error sending audio to Whisper:', error);
        }
    }

    function handleSystemMessageKeydown(event) {
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault(); // Prevent the default line break
            messages[0].content = systemMessage;
        }
    }

    function handleUserMessageKeydown(event) {
        if (event.key === "Enter" && !event.shiftKey) {
            event.preventDefault(); // Prevent the default line break
            interactWithAI();
        }
    }

    function handleKeyDown(event) {
        // Check if Shift key and Spacebar are pressed together
        if (event.shiftKey && event.code === 'Space') {
            event.preventDefault(); // Prevent the default behavior of Shift+Space
            startRecordingForFiveSeconds();
        }
    }

    async function startRecordingForFiveSeconds() {
        isProcessing = true;
        try {
            await startRecording();
            setTimeout(() => {
            if (mediaRecorder && mediaRecorder.state === 'recording') {
                stopRecording();
            } else {
                console.log('Recorder was not in a recording state.');
                isProcessing = false;
            }
            }, 5000);
        } catch (error) {
            console.error('Error during recording setup:', error);
            isProcessing = false;
        }
    }


    async function callAPI(body) {
        const endpoint = "https://api.openai.com/v1/chat/completions";
        const headers = {
            "Authorization": `Bearer ${import.meta.env.VITE_OPENAI_API_KEY}`,
            "Content-Type": "application/json",
            "stream": "true"
        };
        return await fetch(endpoint, {
            method: "POST",
            headers: headers,
            body: JSON.stringify(body)
        });
    }

    async function interactWithAI() {
        isProcessing = true;
        currentProcessingMessage = getRandomProcessingMessage();

        // Add the user's message to the conversation here, just before the API call
        messages = [...messages, {role: "user", content: userInput}];

        const body = {
            model: "gpt-3.5-turbo",
            messages: messages
            
        };

        try {
            const response = await callAPI(body);
            const data = await response.json();

            if (data.choices && data.choices[0] && data.choices[0].message) {
                messages = [...messages, {role: data.choices[0].message.role, content: data.choices[0].message.content}];
            } else {
                messages.push({role: "assistant", content: "Beklager, jeg fulgte ikke med. Kan du gjenta?"});
            }
        } catch (error) {
            console.error("Error interacting with OpenAI:", error);
            messages.push({role: "assistant", content: "Det oppsto en feil. Dan du prøve igjen seinere?"});
        }
        
        // Clear the userInput after the response has been handled
        userInput = '';
        isProcessing = false;
    }


    afterUpdate(() => {
        if (conversationBox.scrollTop < conversationBox.scrollHeight - conversationBox.clientHeight) {
            conversationBox.scrollTop = conversationBox.scrollHeight;
        }
    });

</script>

<div class="system-message-box">
    <label for="system-message">Set System Message:</label>
    <textarea 
        bind:value={systemMessage} 
        placeholder={isProcessing ? currentProcessingMessage : "Skriv system-instrukser her..."} 
        on:keydown={handleSystemMessageKeydown}></textarea>
    <button on:click={() => messages[0].content = systemMessage}>Set Message</button>
</div>

<div class="interaction-box">
    <div class="conversation" bind:this={conversationBox}>
        {#each messages as message}
            <div class="{message.role} message">
                <strong>{message.role}:</strong> {message.content}
            </div>
        {/each}
    </div>
    
    <textarea 
        bind:value={userInput} 
        placeholder= {isProcessing ? currentProcessingMessage : "Du kan skrive her..."}
        on:blur={updateUserInputPlaceholder}
        on:keydown={handleUserMessageKeydown}
    ></textarea>
    <div class="buttons">
        <button class="send" on:click={interactWithAI} disabled={isProcessing}>
            {isProcessing ? "Sender..." : "Send melding"}
        </button>
        <button class="record" on:mousedown={startRecording} on:mouseup={stopRecording}>
            {isRecording ? "Lytter… bare snakk." : "Hold for å snakke"}
        </button>
    </div>

</div>

<style>
 
    .system-message-box, .interaction-box {
        padding: 2em;
        width: 100%;
        max-width: 80%;  /* Added max-width for better responsiveness */
        margin: 1em auto;
        border: 0px solid #ddd;
        border-radius: .5em;

        
    }

    .buttons {

        display: flex;
        flex-direction: row;
        justify-content: space-between;
        flex-wrap: wrap;
        align-items: flex-start;
    }

    textarea {
        width: 100%;
        min-height: 100px;
        padding: 1em;
        border: 1px solid #ddd;
        border-radius: .5em;
        margin-bottom: 1em;

    }

    .conversation {
        overflow-y: auto;
        max-height: 300px;
        border: 1px solid #ddd;
        border-radius: .5em;
        margin-bottom: 2em;
        padding: 1em;
    }

    .user, .assistant {
        padding: 1em;
        margin: 0.5em 0;
        border-radius: .5em;
    }

    .user {
        background-color: #eef;
    }

    .assistant {
        background-color: #eee;
    }

    button {
        width: auto;
        max-width: max-content;
        border-radius: .5em;
        opacity: 1;
        background-color: lightgray;
        padding: 1em;

    }
    button.record {
        background-color: red;
        color: white;
        align-self: flex-end;
    }
    button.send {
        flex: 0 0 auto;
        align-self: flex-start;
        clear: none;
    }
    button:disabled {
        opacity: 0.5;
        cursor: not-allowed;
    }
    
    .conversation {
    display: flex;
    flex-direction: column;
    overflow-y: auto;
    max-height: 300px;
    border: 1px solid #ddd;
    border-radius: .5em;
    margin-bottom: 1em;
    padding: 1em;
    }

    .message {
        max-width: 90%;
        margin: 0.5em 0;
        border-radius: 1em;
        padding: 8px 20px;
        font-size: 14px;
    }

    .user {
        align-self: flex-start; /* Align to the left */
        background-color: #eef; /* Blue-ish for user */
        border-bottom-left-radius: 2px; /* Make top right corner slightly less rounded */
        border-bottom-right-radius: 20px;
    }

    .system {
        border-radius: .5em;
        max-width: 100%;
        background-color: bisque;
    }

    .assistant{
        align-self: flex-end; /* Align to the right */
        background-color: #eee; /* Gray for system/assistant */
        border-bottom-right-radius: 0px; /* Make top left corner slightly less rounded */
        border-bottom-left-radius: 20px;
    }
</style>
