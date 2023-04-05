import { createClient } from '@supabase/supabase-js';

const supabaseUrl = 'your_supabase_url';
const supabaseKey = import.meta.env.VITE_SUPABASE_API_KEY;

export const supabase = createClient(supabaseUrl, supabaseKey);