<script lang="ts">
    let email:string = '';
    let username:string = 'username';
    let password = "";
    let confpassword = "";
    let error = "";
    let success = false;
    let loading = false;
    
    async function PactForge() {
        error = "";

        if (!email || !username || !password) {
            error = 'All fields required'
            return;
        }

        if (password !== confpassword) {
            error = 'Password must match'
            return;
        }
        
        loading = true;

        try {
            const response = await fetch('/api/adduser', 
            {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({email, username, password})
            })

            const data = await response.json();

            if (response.ok) {
                success = true;
                email = "";
                username = "";
                password = "";
                confpassword = "";
            } else {
                error = data.error || 'You shall not pass';
            }
        } catch (err) {
            error = "Network Error. Run it back.";
            console.error('Regisration error:', err);
        } finally {
            loading = false;
        }
    }
</script>

<main>
    <div class="container">
        <h1>Will you face the summit?</h1>

        {#if success}
            <div>
                <p>So the legend begins</p>
                <a href="/user/login">To begin the journey</a>
            </div>
        {:else}
            <form on:submit|preventDefault={PactForge} > 
                <div class="form-group">
                    <label for="email">Email</label>
                    <input
                        id="email"
                        type="email"
                        bind:value={email}
                        placeholder="TheLegend@mountaintop.com"
                        disabled={loading}
                    />
                </div>

                <div class="form-group">
                    <label for="username">username</label>
                    <input
                        id="username"
                        type="username"
                        bind:value={username}
                        placeholder="The man in the mirror"
                        disabled={loading}
                    />
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input
                        id="passwpord"
                        type="passwprd"
                        bind:value={password}
                        placeholder=".*.*.*.*.*."
                        disabled={loading}
                    />
                </div>

                <div class="form-group">
                    <label for="confpassword">Confirm</label>
                    <input
                        id="password"
                        type="password"
                        bind:value={confpassword}
                        placeholder="*.*.*.*.*.*.*"
                        disabled={loading}
                    />
                </div>
            
                {#if error}
                 <div class='error'>
                    {error}
                 </div>
                {/if}

                <button type="submit" disabled={loading}>
                    {loading ? 'Scribing...' : 'Mark the words'}
                </button>

                <p class="login-link">
                    Is your name already in the books? <a href="/user/login">Resume the Climb</a>
                </p>
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