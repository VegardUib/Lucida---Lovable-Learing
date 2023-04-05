<script>    
    // Sanity example code for creating client
    import sanityClient from "@sanity/client";

    const client = sanityClient({
        projectId: "your_sanity_project_id",
        dataset: "your_sanity_dataset",
        apiVersion: "2022-06-01", // Use the current date or the date you created your Sanity project.
        useCdn: false, // `false` if you want to ensure fresh data
    });

    export default client;
</script>