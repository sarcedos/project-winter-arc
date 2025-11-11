<script lang="ts">
    let username = "";
    let password = "";
    let error = "";
    let loading = false;
    let success = false;
    

    async function login() {
        if (!username || !password) {
            error = "I require your details"
            return;
        }

        loading = true;

        try {
            const result = await fetch('/api/login', 
                {
                    method: 'POST',
                    headers:{
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ username, password })
                    
                })
                
            const data = await result.json();

            if (result.ok) {
                success = true;
                username = "";
                password = "";
            } else {
                error = data.error || "The tubes have erred, do try again"
            }
        } catch (err) {
            error = "The tubes have erred. Try once more"
            console.error("An obstacle appears: ", err)
        } finally {
            loading = false;
        }
    }
</script>

<main>
    <div class="container">
        <h1>Once more into the breach?</h1>

        {#if success}
        <p>It appears you've already spoken</p>
        <a href="/user/dashboard">Are you ready?</a>
        {:else}
        <form on:submit|preventDefault={login} >
            <div class="form-group">
                <label for="username">Username</label>
                <input
                    id="username"
                    type="username"
                    bind:value={username}
                    placeholder="Your Name"
                    disabled={loading}
                >
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input
                    id="password"
                    type="password"
                    bind:value={password}
                    placeholder="*.*.*.*.*"
                    disabled={loading}
                >
            </div>

            {#if error}
                <div class=error> 
                    { error }
                </div>
            {/if}

            <button type="submit" disabled={loading}>
                {loading ? "Reading the sagas..." : 'Begin'}
            </button>         
        </form>
        {/if}        
    </div>
</main>

<style>
  main {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background: #f5f5f5;
  }
  
  .container {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    width: 100%;
    max-width: 400px;
  }
  
  h1 {
    margin-top: 0;
    color: #333;
    text-align: center;
  }
  
  .form-group {
    margin-bottom: 1rem;
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem;
    color: #555;
    font-weight: 500;
  }
  
  input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box;
  }
  
  input:focus {
    outline: none;
    border-color: #ff3e00;
  }
  
  input:disabled {
    background: #f5f5f5;
    cursor: not-allowed;
  }
  
  button {
    width: 100%;
    padding: 0.75rem;
    background: #ff3e00;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    margin-top: 1rem;
  }
  
  button:hover:not(:disabled) {
    background: #e63900;
  }
  
  button:disabled {
    background: #ccc;
    cursor: not-allowed;
  }
  
  .error {
    background: #fee;
    color: #c00;
    padding: 0.75rem;
    border-radius: 4px;
    margin-top: 1rem;
  }
  
  .success {
    text-align: center;
  }
  
  .success p {
    color: #0a0;
    font-size: 1.2rem;
    margin-bottom: 1rem;
  }
  
  .login-link {
    text-align: center;
    margin-top: 1rem;
    color: #666;
  }
  
  a {
    color: #ff3e00;
    text-decoration: none;
  }
  
  a:hover {
    text-decoration: underline;
  }
</style>