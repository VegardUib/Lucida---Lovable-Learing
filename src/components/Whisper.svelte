<script type="ts">
// import type { MediaRecorder } from 'types/dom-mediacapture-record';


async function startRecording() {
    audioChunks = [];
    if (isRecording) return;
    isRecording = true;
    isProcessing = true;

    try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });

        let options = {};
        // Check for browser support for the desired MIME type
        const desiredMimeType = 'audio/wav';
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
        // formData.append('language', 'no');
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
            interactWithAI();
        } else {
            console.warn("User input is empty or undefined after transcription.");
        }
    } catch (error) {
        console.error('Error sending audio to Whisper:', error);
    }
}
let isProcessing = false;
</script>
