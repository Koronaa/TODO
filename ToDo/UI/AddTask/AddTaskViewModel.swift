//
//  AddTaskViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import EventKit

enum AddTaskUIType{
    case CREATE
    case UPDATE
}

class AddTaskViewModel{
    
    let modelLayer = ModelLayer()
    
    var currentTask:Task?
    var taskTitle:String = ""
    var selectedDate:Date?
    var selectedCategory:CategoryDTO?
    var categories:[CategoryDTO]?
    var isFavourite:Bool = false
    var isReminder:Bool = false
    
    func addTask(){
        let taskDTO = TaskDTO(name: taskTitle, isFavourite: isFavourite, isReminder: isReminder, dateTime: selectedDate ?? Date())
        modelLayer.addTask(for: taskDTO, categoryDTO: selectedCategory)
        
        if isReminder{
            addReminder(for: taskDTO)
        }
        
    }
    
    func getCategories(onCompleted:@escaping()->Void){
        self.categories = modelLayer.getCategories()
        onCompleted()
    }
    
    func updateData(from task:Task){
        self.taskTitle = task.name
        self.selectedDate = task.dateTime
        self.isReminder = task.isReminder
        self.isFavourite = task.isFavourite
        selectSpecificCategory(for: task.category?.name)
    }
    
    private func selectSpecificCategory(for name:String?){
        if let _ = name, let _ = self.categories{
            for category in self.categories!{
                if category.name == name{
                    category.isSelected = true
                    selectedCategory = category
                }else{
                    category.isSelected = false
                }
            }
        }
    }
    
    func deleteTask(){
        modelLayer.dataLayer.deleteTask(task: currentTask!)
        
        if currentTask!.isReminder{
            deleteReminder(for: currentTask!)
        }
        
    }
    
    func updateTask(){
        let updatedCategory = modelLayer.dataLayer.getCategoryByName(name: selectedCategory?.name)
        let updatedTask = TaskDTO(name: taskTitle, isFavourite: isFavourite, isReminder: isReminder, dateTime: selectedDate ?? Date())
        modelLayer.dataLayer.updateTask(currentTask: currentTask!, updatedTask: updatedTask, updatedCategory: updatedCategory)
        
        if isReminder{
            updateReminder(for: currentTask!, updatedTask: updatedTask)
        }
    }
    
    //MARK: Reminder Manager
    
    func getReminders() {
        modelLayer.taskReminderManager.fetchAllReminders()
    }
    
    func addReminder(for taskDTO:TaskDTO){
        modelLayer.taskReminderManager.addReminder(for: taskDTO)
    }
    
    private func getReminder(for currentTask:Task) -> EKReminder?{
        
        let fileredReminders = modelLayer.taskReminderManager.reminders.filter{ $0.title == currentTask.name && $0.dueDateComponents == Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: currentTask.dateTime) }
        if fileredReminders.count > 0{
            return fileredReminders.first
        }else{
            return nil
        }
    }
    
    func deleteReminder(for currentTask:Task){
        if let reminder = getReminder(for: currentTask){
            modelLayer.taskReminderManager.removeReminder(reminder: reminder)
        }
    }
    
    func updateReminder(for currentTask:Task,updatedTask:TaskDTO){
        if let reminder = getReminder(for: currentTask){
            modelLayer.taskReminderManager.updateReminder(fro: reminder, updatedTask: updatedTask)
        }
    }
}
