<script lang="ts">
    import { onMount } from 'svelte'

    let users: any[] = [];
    let loading = true;

    onMount(async () =>{
        try {
            const response = await fetch('/api/pullusers');
            users = await response.json()
        } catch (error) {
            console.error('Error fetching users: ', error);
        } finally {
            loading = false;
        }
    });
</script>

<main>
    <h1>Project Winter Arc</h1>

    {#if loading}
        <p>Warming things up</p>
    {:else}
        <h2>Current Players</h2>
        <ul>
            {#each users as user}
            <li>{user.username} - {user.email}</li>
            {/each}
        </ul>
    {/if}
</main>

<style>
    main {
        padding:2rem;
        max-width:800px;
        margin: 0 auto;
    }

    h1 {
        color:blue;
    }
</style>