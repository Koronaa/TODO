//
//  EventeReminderManager.swift
//  ToDo
//
//  Created by Sajith Konara on 6/15/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import EventKit
import RxRelay

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
    
    func removeReminder(reminder:EKReminder) -> BehaviorRelay<(Bool,CustomError?)>{
        do{
            try eventStore.remove(reminder, commit: true)
        }catch{
            return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: "Reminder Error", message: error.localizedDescription)))
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
    }
    
    func addReminder(for task:TaskDTO) -> BehaviorRelay<(Bool,CustomError?)>{
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
            return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: "Reminder Error", message: error.localizedDescription)))
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
    }
    
    func updateReminder(fro reminder:EKReminder,updatedTask:TaskDTO) -> BehaviorRelay<(Bool,CustomError?)>{
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
            return BehaviorRelay<(Bool,CustomError?)>(value: (false,CustomError(title: "Reminder Error", message: error.localizedDescription)))
        }
        return BehaviorRelay<(Bool,CustomError?)>(value: (true,nil))
    }
}
