<script>
    // Supabase example code for creating client
    import supabase from "../lib/supabase";
    
    // Use the supabase client to interact with your Supabase project.
    // For example, fetching data from a table called 'my_table':
    async function fetchData() {
      const { data, error } = await supabase.from("my_table").select("*");
      if (error) {
        console.error("Error fetching data:", error);
      } else {
        console.log("Data fetched:", data);
      }
    }
  </script>  