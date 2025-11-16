<script lang="ts">
    import { event } from 'svelte';


    let { goal_id: number, show: boolean} = $props

    let title="";
    let description = "";
    let points "";
    let due_date = "";
    let loading = false;
    let error = "";

    async function handleSubmit() {
        error = "";

        if (!title.trim()) {
            error = "A thing must have a name";
            return
        }

        loading = true;

        try {
            const response = await fetch("/api")
        }
    }
</script>