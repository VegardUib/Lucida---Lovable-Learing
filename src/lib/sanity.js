import sanityClient from '@sanity/client';

export const sanity = sanityClient({
  projectId: 'your_project_id',
  dataset: 'your_dataset',
  token: import.meta.env.VITE_SANITY_API_TOKEN,
  useCdn: false,
});