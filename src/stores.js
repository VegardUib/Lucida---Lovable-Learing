import { writable } from 'svelte/store';

export const userInput = writable("");
export const isProcessing = writable(false);
export const isRecording = writable(false);
export const messages = writable([]);
export const summary = writable("");

/*export const messages = writable([
    { role: "system", content: "Initial system message." }
]);
*/