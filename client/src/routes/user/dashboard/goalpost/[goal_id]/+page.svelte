<script lang="ts">
  import { page } from '$app/stores';
  import { onMount } from 'svelte';
  import { Taskform } from '$lib/TaskForm.svelte';  
  // Extract goalId from URL
  let goal_id = $derived($page.params.goal_id);;
  
  let test: any = null;
  let goal: any = null;
  let tasks: any[] = [];
  let loading = true;
  let error = '';
  let showtaskform = $state(false);
  
  onMount(async () => {
    await loadGoalData();
  });
  
  async function loadGoalData() {
    loading = true;
    console.log("testing")
    try {
      // Fetch the goal
      const goalResponse = await fetch(`/api/goals/getgoals/${goal_id}`);
      if (!goalResponse.ok) throw new Error('Goal not found');
      test = await goalResponse.json();
      goal = test[0]
      

      // Fetch tasks for this goal
      const tasksResponse = await fetch(`/api/tasks/gettasks/${goal_id}`);
      tasks = await tasksResponse.json();
      
    } catch (err) {
      error = 'Failed to load goal';
      console.error(err);
    } finally {
      loading = false;
    }
  }
  
  async function toggleTaskComplete(taskId: number, currentStatus: boolean) {
    try {
      const response = await fetch(`/api/tasks/${taskId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ completed: !currentStatus })
      });
      
      if (response.ok) {
        // Reload tasks
        await loadGoalData();
      }
    } catch (err) {
      console.error('Failed to update task:', err);
    }
  }
</script>

{#if loading}
  <div class="loading">Loading goal...</div>

{:else if error}
  <div class="error">{error}</div>
  <a href="/goals">Back to goals</a>

{:else if goal}
  <main>
    <div class="header">
      <a href="/goals">← Back to Goals</a>
      <h1>{goal.title}</h1>
      {#if goal.description}
        <p class="description">{ goal.description }</p>
      {/if}
      <span class="status">{ goal.status }</span>
    </div>
    
    <section class="tasks">
      <h2>Tasks</h2>
      
      {#if tasks.length === 0}
        <p class="empty">No tasks yet. Add one to get started!</p>
      {:else}
        <ul class="task-list">
          {#each tasks as task}
            <li class:completed={task.completed}>
              <!-- <input 
                type="checkbox" 
                checked={task.completed}
                on:change={() => toggleTaskComplete(task.id, task.completed)}
              /> -->
              <div class="task-info">
                <span class="task-title">{task.title}</span>
                {#if task.due_date}
                  <span class="due-date">Due: {new Date(task.due_date).toLocaleDateString()}</span>
                {/if}
                {#if task.points}
                  <span class="points">{task.points} pts</span>
                {/if}
              </div>
            </li>
          {/each}
        </ul>
      {/if}
      
      <button class="add-task" onclick={()=> showtaskform=true}>+ Add Task</button>
    </section>
  </main>

      <TaskForm
    goal_id={paresInt(goal_id)}
    bind:show={showtaskform}
    ontaskAdded={loadGoalData}
    />
{/if}

<style>
  main {
    max-width: 800px;
    margin: 0 auto;
    padding: 2rem;
  }
  
  .header {
    margin-bottom: 2rem;
  }
  
  .header a {
    color: #ff3e00;
    text-decoration: none;
    margin-bottom: 1rem;
    display: inline-block;
  }
  
  h1 {
    margin: 0.5rem 0;
    color: #333;
  }
  
  .description {
    color: #666;
    margin: 0.5rem 0;
  }
  
  .status {
    display: inline-block;
    padding: 0.25rem 0.75rem;
    background: #e0e0e0;
    border-radius: 12px;
    font-size: 0.875rem;
    margin-top: 0.5rem;
  }
  
  .tasks {
    background: white;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  }
  
  h2 {
    margin-top: 0;
  }
  
  .task-list {
    list-style: none;
    padding: 0;
    margin: 1rem 0;
  }
  
  .task-list li {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-bottom: 0.5rem;
  }
  
  .task-list li.completed {
    opacity: 0.6;
  }
  
  .task-list li.completed .task-title {
    text-decoration: line-through;
  }
  
  .task-info {
    flex: 1;
    display: flex;
    gap: 1rem;
    align-items: center;
  }
  
  .task-title {
    font-weight: 500;
  }
  
  .due-date, .points {
    font-size: 0.875rem;
    color: #666;
  }
  
  .empty {
    text-align: center;
    color: #999;
    padding: 2rem;
  }
  
  .add-task {
    width: 100%;
    padding: 0.75rem;
    background: #ff3e00;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 1rem;
  }
  
  .add-task:hover {
    background: #e63900;
  }
  
  .loading, .error {
    text-align: center;
    padding: 2rem;
  }
</style>