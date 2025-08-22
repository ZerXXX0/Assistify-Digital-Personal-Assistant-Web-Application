package model;

import config.DB;
import java.util.ArrayList;
import java.util.List;

public abstract class Task {
   protected int id;
   protected String title;
   protected int userId;

   // Constructors
   public Task() {}
   
   public Task(String title) {
       this.title = title;
   }
   
   public Task(int id, String title, int userId) {
       this.id = id;
       this.title = title;
       this.userId = userId;
   }

   // Abstract methods to be implemented by subclasses
   public abstract boolean saveToDatabase(DB db);
   public abstract boolean updateTask(DB db);
   public abstract boolean deleteTask(DB db);

   // Static method to get all tasks (both ToDoItems and Activities)
   public static List<Task> getAllTasks(DB db, int userId) {
       List<Task> allTasks = new ArrayList<>();
       
       // Add all ToDoItems
       List<ToDoItem> todoItems = ToDoItem.getAllToDoItems(db, userId);
       allTasks.addAll(todoItems);
       
       // Add all Activities
       List<Activity> activities = Activity.getAllActivities(db, userId);
       allTasks.addAll(activities);
       
       return allTasks;
   }

   // Getters and Setters
   public int getId() {
       return id;
   }

   public void setId(int id) {
       this.id = id;
   }

   public String getTitle() {
       return title;
   }

   public void setTitle(String title) {
       this.title = title;
   }
   
   public int getUserId() {
       return userId;
   }
   
   public void setUserId(int userId) {
       this.userId = userId;
   }
}
