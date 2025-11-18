<script lang="ts">
	
    let { goalId, show = $bindable(false), ontaskAdded }: {
    goalId: number;
    show?: boolean;
    ontaskAdded?: () => void;
    } = $props();

    let title= $state("");
    let description = $state("");
    let due_date = $state("");
    let loading = $state(false);
    let error = $state("");

    async function handleSubmit() {
        error = "";

        if (!title.trim()) {
            error = "A thing must have a name";
            return
        }

        loading = true;

        try {
            const response = await fetch("/api/tasks/addtask", {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    goal_id: goal_id,
                    title: title.trim(),
                    description: description.trim() || null,
                    due_date: due_date
                })
            });

            if (response.ok) {
                title = "";
                description = "";
                due_date = "";
                ontaskAdded?.();

                show = false
            } else {
            const data = await response.json();
            error = data.error || "failed to create task"
            }

        } catch (err) {
            error = "network error";
            console.error('Task creation error ', err)
        } finally {
            loading = false;
            error = "";
        }
    }

    function cancel() {
        show = false;
        error = "";
    }
</script>

{#if show}
    <div class="modal-backdrop" onclick={cancel}>
        <div class="modal" onclick={(e)=> e.stopPropagation()}>
            <h2> Add New Task</h2>

            <form onsubmit={(e) => {preventDefault(); handleSubmit() }}>
                <div class="form-group">
                    <label for="title">Task Title</label>
                    <input
                    id="title"
                    type="text"
                    bind:value={title}
                    placeholder="What is to be done?"
                    disabled={loading}
                    required
                    />
                </div>

                <div class="form-group">
                    <label for="description">Describe the task</label>
                    <input
                    id="description"
                    type="text"
                    bind:value={description}
                    placeholder="Tell me of this task"
                    disabled={loading}
                    required
                    />
                </div>

                <div class=form-group>
                    <label for=due-date>When shall it be done?</label>
                    <input
                    id="due_date"
                    type="date"
                    bind:value={due_date}
                    disabled={loading}
                    />
                </div>

                {#if error}
                    <div class="error">{ error }</div>
                {/if}

                <div class="button-group">
                    <button type="button" class="cancel" onclick={cancel} disabled={loading}>
                        Cancel
                    </button>
                    <button type="submit" class="submit" onclick={handleSubmit} disabled={loading}>
                        {loading ? "Marking it down..." : "Declare it"}
                    </button>
                </div>
            </form>
        </div> 
    </div>
{/if}

<style>
  /* All your existing styles stay the same */
  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }
  
  .modal {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    max-width: 500px;
    width: 90%;
    max-height: 90vh;
    overflow-y: auto;
  }
  
  h2 {
    margin-top: 0;
    color: #333;
  }
  
  .form-group {
    margin-bottom: 1rem;
  }
  
  .form-row {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
  }
  
  label {
    display: block;
    margin-bottom: 0.5rem;
    color: #555;
    font-weight: 500;
  }
  
  input, textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    box-sizing: border-box;
    font-family: inherit;
  }
  
  input:focus, textarea:focus {
    outline: none;
    border-color: #ff3e00;
  }
  
  input:disabled, textarea:disabled {
    background: #f5f5f5;
    cursor: not-allowed;
  }
  
  .error {
    background: #fee;
    color: #c00;
    padding: 0.75rem;
    border-radius: 4px;
    margin-bottom: 1rem;
  }
  
  .button-group {
    display: flex;
    gap: 1rem;
    margin-top: 1.5rem;
  }
  
  button {
    flex: 1;
    padding: 0.75rem;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
  }
  
  .cancel {
    background: #e0e0e0;
    color: #333;
  }
  
  .cancel:hover:not(:disabled) {
    background: #d0d0d0;
  }
  
  .submit {
    background: #ff3e00;
    color: white;
  }
  
  .submit:hover:not(:disabled) {
    background: #e63900;
  }
  
  button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style>