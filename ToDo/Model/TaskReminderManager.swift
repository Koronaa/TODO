//
//  EventeReminderManager.swift
//  ToDo
//
//  Created by Sajith Konara on 6/15/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import EventKit

class TaskReminderManager:NSObject{
    
    var eventStore:EKEventStore!
    var reminders:[EKReminder]
    
    override init() {
        eventStore = EKEventStore()
        reminders = []
    }
    
    private func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler){
        eventStore.requestAccess(to: .reminder) { (acessGranted, error) in
            completion(acessGranted,error)
        }
    }
    
    private func getAuthorizationStatus() -> EKAuthorizationStatus{
        return EKEventStore.authorizationStatus(for: .reminder)
    }
    
    func fetchAllReminders(){
        switch getAuthorizationStatus() {
        case .authorized:
            let predicate = self.eventStore.predicateForReminders(in: nil)
            self.eventStore.fetchReminders(matching: predicate) { (reminders) in
                if let savedReminders = reminders{
                    self.reminders = savedReminders
                }
            }
        case .notDetermined:
            requestAccess { (accessGranted, error) in
                if accessGranted{
                    let predicate = self.eventStore.predicateForReminders(in: nil)
                    self.eventStore.fetchReminders(matching: predicate) { (reminders) in
                        if let savedReminders = reminders{
                            self.reminders = savedReminders
                        }
                    }
                }
            }
        case .denied,.restricted:
            print("error")
        default:
            print("Not Supported")
        }
    }
    
    func removeReminder(reminder:EKReminder){
        do{
            try eventStore.remove(reminder, commit: true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func addReminder(for task:TaskDTO){
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = task.name
        reminder.dueDateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: task.dateTime)
        if let calender = eventStore.defaultCalendarForNewReminders(){
            reminder.calendar  = calender
        }else{
            reminder.calendar = EKCalendar(for: .reminder, eventStore: eventStore)
        }
        reminder.alarms?.append(EKAlarm(absoluteDate: task.dateTime))
        do{
            try eventStore.save(reminder, commit: true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func updateReminder(fro reminder:EKReminder,updatedTask:TaskDTO){
        reminder.title = updatedTask.name
        reminder.dueDateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: updatedTask.dateTime)
        if let calender = eventStore.defaultCalendarForNewReminders(){
            reminder.calendar  = calender
        }else{
            reminder.calendar = EKCalendar(for: .reminder, eventStore: eventStore)
        }
        reminder.alarms?.append(EKAlarm(absoluteDate: updatedTask.dateTime))
        do{
            try eventStore.save(reminder, commit: true)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
}
