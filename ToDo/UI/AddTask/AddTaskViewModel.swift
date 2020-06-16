//
//  AddTaskViewModel.swift
//  ToDo
//
//  Created by Sajith Konara on 6/11/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import EventKit
import RxRelay
import RxSwift

enum AddTaskUIType{
    case CREATE
    case UPDATE
}

class AddTaskViewModel{
    
    var UIType:AddTaskUIType
    
    init(UIType:AddTaskUIType) {
        self.UIType = UIType
    }
    
    let modelLayer = ModelLayer()
    let bag = DisposeBag()
    
    var currentTask:Task?
    var taskTitle:String = ""
    var selectedDate:Date?
    var selectedCategory:CategoryDTO?
    var translatedCategories:BehaviorRelay<[CategoryDTO]> = BehaviorRelay<[CategoryDTO]>(value: [])
    var isFavourite:Bool = false
    var isReminder:Bool = false
    var headerLabel:String = ""
    var buttonTitle:String = ""
    
    var translatedCategoryCount:Int{
        return translatedCategories.value.count
    }
    
    
    func setupDataForView(){
        if UIType == .CREATE{
            headerLabel = "Add Task"
            buttonTitle = "Add Task"
        }else{
            headerLabel = "Update Task"
            buttonTitle = "Update Task"
        }
    }
    
    
    func addTask() -> BehaviorRelay<(Bool,CustomError?)>{
        var isTaskAdded:Bool  = false
        var isReminderAdded:Bool = false
        var receivedError:CustomError?
        let taskDTO = TaskDTO(name: taskTitle, isFavourite: isFavourite, isReminder: isReminder, dateTime: selectedDate ?? Date())
        modelLayer.addTask(for: taskDTO, categoryDTO: selectedCategory).asObservable()
            .subscribe(onNext: { (isAdded,error) in
                receivedError = error
                isTaskAdded = isAdded
                if isAdded{
                    if self.isReminder{
                        self.addReminder(for: taskDTO).asObservable().subscribe(onNext: { (isAdded,error) in
                            isReminderAdded = isAdded
                            receivedError = error
                        }).disposed(by: self.bag)
                    }
                }
            }).disposed(by: bag)
        
        //Priority goes for task
            if isTaskAdded && isReminderAdded{
                return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
            }else if isTaskAdded && !isReminderAdded{
                return BehaviorRelay<(Bool,CustomError?)>(value: (true,receivedError))
            }else{
                return BehaviorRelay<(Bool,CustomError?)>(value: (false,receivedError))
            }
        
        
    }
    
    func getTranslatedCategories(){
        modelLayer.getTranslatedCategories().asObservable()
            .subscribe(onNext: { translatedCategories in
                self.translatedCategories.accept(translatedCategories)
            }).disposed(by: bag)
        
    }
    
    func updateData(from task:Task){
        self.taskTitle = task.name
        self.selectedDate = task.dateTime
        self.isReminder = task.isReminder
        self.isFavourite = task.isFavourite
        selectSpecificCategory(for: task.category?.name)
    }
    
    private func selectSpecificCategory(for name:String?){
        if let _ = name{
            for category in self.translatedCategories.value{
                if category.name == name{
                    category.isSelected = true
                    selectedCategory = category
                }else{
                    category.isSelected = false
                }
            }
        }
    }
    
    func deleteTask() -> BehaviorRelay<(Bool,CustomError?)>{
        var isTaskDeleted:Bool  = false
        var isReminderDeleted:Bool = false
        var receivedError:CustomError?
        let wasTaskAReminder:Bool = currentTask!.isReminder
        
        modelLayer.dataLayer.deleteTask(task: currentTask!).asObservable()
            .subscribe(onNext: { (taskDeleted,error) in
                isTaskDeleted = taskDeleted
                receivedError = error
                if taskDeleted{
                    if wasTaskAReminder{
                        self.deleteReminder(for: self.currentTask!).asObservable()
                            .subscribe(onNext: { (reminderDeleted,error) in
                                isReminderDeleted = taskDeleted
                                receivedError = error
                            }).disposed(by: self.bag)
                    }
                }
            }).disposed(by: bag)
        
        
            if isTaskDeleted && isReminderDeleted{
                return BehaviorRelay<(Bool,CustomError?)>(value: (true, nil))
            }else if isTaskDeleted && !isReminderDeleted{
                return BehaviorRelay<(Bool,CustomError?)>(value: (true, receivedError))
            }else{
                return BehaviorRelay<(Bool,CustomError?)>(value: (false, receivedError))
            }
        
    }
    
    func updateTask() -> BehaviorRelay<(Bool,CustomError?)>{
        var taskUpdated:Bool  = false
        var reminderUpdated:Bool = false
        var receivedError:CustomError?
        let updatedCategory = modelLayer.dataLayer.getCategoryByName(name: selectedCategory?.name)
        let updatedTask = TaskDTO(name: taskTitle, isFavourite: isFavourite, isReminder: isReminder, dateTime: selectedDate ?? Date())
        let taskWasAReminder:Bool = currentTask!.isReminder
        
        modelLayer.dataLayer.updateTask(currentTask: currentTask!, updatedTask: updatedTask, updatedCategory: updatedCategory).asObservable()
            .subscribe(onNext: { (isTaskUpdated,error) in
                taskUpdated = isTaskUpdated
                receivedError = error
                if isTaskUpdated{
                    if taskWasAReminder{
                        if self.isReminder{
                            self.updateReminder(for: self.currentTask!, updatedTask: updatedTask).asObservable()
                                .subscribe(onNext: { (isReminderUpdated,error) in
                                    reminderUpdated = isReminderUpdated
                                    receivedError = error
                                }).disposed(by: self.bag)
                        }else{
                            self.deleteReminder(for: self.currentTask!).asObservable()
                            .subscribe(onNext: { (isReminderDeleted,error) in
                                reminderUpdated = isReminderDeleted
                                receivedError = error
                            }).disposed(by: self.bag)
                        }
                    }else{
                        if self.isReminder{
                            self.addReminder(for: updatedTask).asObservable()
                            .subscribe(onNext: { (isReminderCreated,error) in
                                reminderUpdated = isReminderCreated
                                receivedError = error
                            }).disposed(by: self.bag)
                        }
                    }
                }
            }).disposed(by: bag)
        
        
        if taskUpdated && reminderUpdated{
            return BehaviorRelay<(Bool,CustomError?)>(value: (true, nil))
        }else if taskUpdated && !reminderUpdated{
            return BehaviorRelay<(Bool,CustomError?)>(value: (true, receivedError))
        }else{
            return BehaviorRelay<(Bool,CustomError?)>(value: (false, receivedError))
        }
        

    }
    
    //MARK: Reminder Manager
    
    func getReminders() {
        modelLayer.taskReminderManager.fetchAllReminders()
    }
    
    private func addReminder(for taskDTO:TaskDTO) -> BehaviorRelay<(Bool,CustomError?)>{
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
    
    private func deleteReminder(for currentTask:Task) -> BehaviorRelay<(Bool,CustomError?)>{
        if let reminder = getReminder(for: currentTask){
            return modelLayer.taskReminderManager.removeReminder(reminder: reminder)
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: "Reminder Error", message: "Couldn't find any reminders for this specific task")))
    }
    
    private func updateReminder(for currentTask:Task,updatedTask:TaskDTO) -> BehaviorRelay<(Bool,CustomError?)>{
        if let reminder = getReminder(for: currentTask){
            return modelLayer.taskReminderManager.updateReminder(fro: reminder, updatedTask: updatedTask)
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: "Reminder Error", message: "Couldn't find any reminders for this specific task")))
    }
}
