//
//  BLETasksCenter.swift
//  YYBLEDemo1
//
//  Created by zk-fuhuayou on 2021/4/29.
//

import UIKit
import CoreBluetooth
protocol BLETasksCenterProtocol: NSObject {
    func iSendData(data: Any, service: String, characteristic: String, type:BLETaskWriteType, callback: BLECALLBACK?)
    func iConnectDevice(device:BLEDevice, callback: BLECALLBACK?)
    func iRetrieveConnect(serviceUUID:String?, callback: BLECALLBACK?)
    func iReconnect(callback: BLECALLBACK?)
    func iDisconnect(callback: BLECALLBACK?)
    func iReadData(service: String, characteristic: String, callback: BLECALLBACK?)
    func iConnectWithServiceUUID(uuids: [String], timeout:Int, scanService:String?, deviceName:String?, callback: BLECALLBACK?)
    func iOta(filePath:String, progressCallback:BLECALLBACK?, callback: BLECALLBACK?)
}

//swiftlint:disable empty_count force_unwrapping force_cast syntactic_sugar type_body_length file_length
class BLETasksCenter {
    
    weak var delegate: BLETasksCenterProtocol?
    
    /**
     系统级任务队列。直接利用串行队列处理**/
    
    /*串行队列*/
    var tasks = NSMutableArray()
    //sync waitting task
    var syncWaitingTask:BLETask?
    let lock = NSLock()
    var isTasking = false
    
    /**
     异步队列
     */
    var isAsyncTasking = false
    var asyncTasks = NSMutableArray()
    var asyncWaitingTasks = NSMutableArray()
    let asyncWaitingTasksLock = NSLock()
    
    func executeSystemSyncTask(type:BLETaskType = .normal,
                               priority:BLETaskPriority = .height,
                               timeout:Float = 5.0,
                               parameters:[String:Any]? = nil,
                               completedBlock:(([String: Any]) -> Void)? = nil,
                               progressBlock:BLECALLBACK? = nil) {
        let task = BLETask(type: type, priority: priority, timeout: timeout, parameters: parameters, resonseBlock: completedBlock)
        task.progressBlock = progressBlock
        if type == .disconnect {
            self.execDisconnectTask(task: task)
        } else {
            self.addTask(task: task)
            self.execute()
        }
        
    }
    
    func executeTask(data:Any?,
                     service:String?,
                     characteristic:String?,
                     type:BLETaskType = .normal,
                     writeReadType: BLETaskWriteType = .withoutResponse,
                     resonseService: String? = nil,
                     resonseCharacteristic: String? = nil,
                     priority:BLETaskPriority = .default,
                     isAsync:Bool = false,
                     identifier:String? = nil,
                     completedBlock:(([String: Any]) -> Void)? = nil) {
        self.addTaskToQueue(data: data,
                            service: service,
                            characteristic: characteristic,
                            type: type,
                            writeReadType: writeReadType,
                            resonseService: resonseService,
                            resonseCharacteristic: resonseCharacteristic,
                            priority: priority,
                            isAsync: isAsync,
                            identifier: identifier,
                            completedBlock: completedBlock)
        isAsync ? self.asyncExecute() : execute()
    }

    private func execute() {
        DispatchQueue.global().async {
            print("================ is tasking: ", self.isTasking)
            print("================ self.tasks.count: ", self.tasks.count)
            if self.isTasking {
                return
            }
            self.isTasking = true
            let task = self.getTask()
            //no task, then return.
            if task == nil {
                self.isTasking = false
                return
            }
            
            if task!.taskType == BLETaskType.normal {
                //check if the service and characteristic exist.
                if task!.service == nil || task!.characteristic == nil {
                    task!.taskCompleted(response: ["state":false, "message":"Service or characteristic nil."])
                    self.isTasking = false
                    self.execute() //next task.
                    return
                }
                
                if task!.writeReadType == .withResponse {
                    self.syncWaitingTask = task
                    task!.execute() //execute timer.
                }
                
                if self.delegate != nil {
                    self.delegate!.iSendData(data:task!.cmdData as Any,
                                             service:task!.service!,
                                             characteristic:task!.characteristic!,
                                             type:task!.writeReadType,
                                             callback: { (val:[String : Any]) in     // state: Bool, message: String
                                                let state = val["state"] as! BLETaskState
                                                if task!.writeReadType == .withoutResponse || state == .fail {
                                                    task?.taskCompleted(response: val)
                                                    self.syncWaitingTask = nil
                                                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1, execute: {
                                                        self.isTasking = false
                                                        self.execute() //next task.
                                                    })
                                                }
                                             })
                } else {
                    task?.taskCompleted(response: ["state":BLETaskState.fail, "message":"Not set the ble center."])
                    self.syncWaitingTask = nil
                    self.isTasking = false
                    self.execute() //next task.
                }
            } else if task!.taskType == .readData {
                self.executeReadTask(task: task!)
            } else { //系统级别
                self.executeSystemTask(task: task)
            }
        }
    }
    
    private func executeReadTask(task:BLETask) {
        if task.writeReadType == .withResponse {
            self.syncWaitingTask = task
            task.execute() //execute timer.
        }
        self.delegate?.iReadData(service: task.service!,
                                 characteristic: task.characteristic!, callback: { response in
                                    task.taskCompleted(response: response)
                                    self.syncWaitingTask = nil
                                    self.isTasking = false
                                    self.execute() //next task.
                                })
    }
    
    func execDisconnectTask(task:BLETask) {
        self.isTasking = true
        self.removeAllTasks()
        self.syncWaitingTask = nil
        self.delegate?.iDisconnect(callback: { response in
            task.taskCompleted(response: response)
            self.syncWaitingTask = nil
            self.removeAllTasks()
            self.isTasking = false
            self.execute() //next task.
        })
    }
    
    private func executeSystemTask(task:BLETask?) {
        if let task = task {
            switch task.taskType {
            case .connectWithDevice:
                self.syncWaitingTask = task
                let device = task.parameters![BLEConstants.DEVICE] as! BLEDevice
                self.delegate?.iConnectDevice(device:device, callback: { response in
                    task.taskCompleted(response: response)
                    self.syncWaitingTask = nil
                    self.isTasking = false
                    self.execute() //next task.
                })
            case .connectWithServerUUID:
                self.syncWaitingTask = task
                task.execute() //启动超时计时器。
                let uuids = task.parameters![BLEConstants.SERVICE_UUIDS] as! [String]
                let timeout = task.parameters![BLEConstants.BLE_TIMEOUT] as! Int
                let deviceName = task.parameters![BLEConstants.BLE_DEVICE_NAME] as? String
                let scanService = task.parameters![BLEConstants.BLE_SCAN_SERVICE] as? String
                self.delegate?.iConnectWithServiceUUID(uuids: uuids, timeout: timeout, scanService: scanService, deviceName: deviceName) {res in
                    task.taskCompleted(response: res)
                    self.syncWaitingTask = nil
                    self.isTasking = false
                    self.execute() //next task.
                }
            case .connectFromConnectedList:
                self.syncWaitingTask = task
                let serviceUUID = task.parameters![BLEConstants.SERVICE_UUID] as! String
                self.delegate?.iRetrieveConnect(serviceUUID: serviceUUID, callback: { response in
                    task.taskCompleted(response: response)
                    self.syncWaitingTask = nil
                    self.isTasking = false
                    self.execute() //next task.
                })
            case .reconnect:
                self.syncWaitingTask = task
                self.delegate?.iReconnect { response in
                    task.taskCompleted(response: response)
                    self.syncWaitingTask = nil
                    self.isTasking = false
                    self.execute() //next task.
                }
            case .disconnect:
                self.syncWaitingTask = task
                self.delegate?.iDisconnect(callback: { response in
                    task.taskCompleted(response: response)
                    self.syncWaitingTask = nil
                    
                    //cancle all tasks.
                    self.removeAllTasks()
                    
                    self.isTasking = false
                    self.execute() //next task.
                })
            case .ota:
                self.syncWaitingTask = task
//                self.removeAllTasks() //before ota, remove all tasks.
                let filePath = task.parameters!["filePath"] as! String
                self.delegate?.iOta(filePath:filePath, progressCallback: { progress in
                    task.progressBlock?(progress)
                }, callback: {response in
                    self.syncWaitingTask?.taskCompleted(response: response)
                    self.syncWaitingTask = nil
                    self.isTasking = false
                    self.execute() //next task.
                })
            default:
                break
            }
        }
    }
    
    private func asyncExecute() {
        DispatchQueue.global().async {
            if self.isAsyncTasking {
                return
            }
            self.isAsyncTasking = true
            let task = self.getTask(isAsync: true)
            self.removeTask(task: task, isAsync: true)
            //no task, then return.
            if task == nil {
                self.isAsyncTasking = false
                return
            }
            
            //check if the service and characteristic exist.
            if task!.service == nil || task!.characteristic == nil {
                task!.taskCompleted(response: ["state":false, "message":"Service or characteristic nil."])
                self.isAsyncTasking = false
                self.asyncExecute() //next task.
                return
            }
            
            if task!.writeReadType == .withResponse {
                self.asyncWaitingTasksLock.lock()
                self.asyncWaitingTasks.add(task!)
                self.asyncWaitingTasksLock.unlock()
                task!.execute() //execute timer.
            }
            
            if self.delegate != nil {
                self.delegate!.iSendData(data:task!.cmdData,
                                         service:task!.service!,
                                         characteristic:task!.characteristic!,
                                         type:task!.writeReadType,
                                         callback: { (val:[String : Any]) in     // state: Bool, message: String
                                            let state = val["state"] as! BLETaskState
                                            if task!.writeReadType == BLETaskWriteType.withoutResponse || state == BLETaskState.fail {
                                                task?.taskCompleted(response: val)
                                                self.asyncWaitingTasksLock.lock()
                                                self.asyncWaitingTasks.remove(task!)
                                                self.asyncWaitingTasksLock.unlock()
                                            }
                                         })
            } else {
                task?.taskCompleted(response: ["state":BLETaskState.fail, "message":"Not set the ble center."])
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                self.isAsyncTasking = false
                self.asyncExecute() //next task.
            }
        }
    }
    
    func writeWithResonseTaskFinished(state:BLETaskState, task:BLETask, error: Error?) {
        task.taskCompleted(response: ["state": state,
                                      "message": error != nil ? error!.localizedDescription : "success",
                                      "value":(task.resonseData ?? NULL_DATA())])
        if !task.isAsync {
            self.syncWaitingTask = nil
            self.isTasking = false
            self.execute() //next task.
        }
    }
    
    func addTaskToQueue(data:Any?,
                        service:String?,
                        characteristic:String?,
                        type:BLETaskType = .normal,
                        writeReadType: BLETaskWriteType = .withoutResponse,
                        resonseService: String? = nil,
                        resonseCharacteristic: String? = nil,
                        priority:BLETaskPriority = .default,
                        isAsync:Bool = false,
                        identifier:String? = nil,
                        completedBlock:(([String: Any]) -> Void)? = nil) {
        if service == nil || characteristic == nil {
            completedBlock?([BLEConstants.STATE: BLETaskState.fail, BLEConstants.MESSAGE:"Service or characteristic nil."])
            return
        }
        
        if  type == .normal && data == nil {
            completedBlock?([BLEConstants.STATE: BLETaskState.fail, BLEConstants.MESSAGE:"Data nil."])
            return
        }
        
        let newTask = BLETask(data:data,
                              service: service,
                              characteristic: characteristic,
                              type: type,
                              writeReadType: writeReadType,
                              resonseService: resonseService,
                              resonseCharacteristic: resonseCharacteristic,
                              priority: priority,
                              isAsync: isAsync,
                              identifier: identifier,
                              resonseBlock:completedBlock)
        addTask(task: newTask)
    }
    
    func addTask(task:BLETask?) {
        if let task = task {
            DispatchQueue.global().sync {
                self.lock.lock()
                //finished block.
                task.tasksCenterBlock = {[weak self] task in
                    if task.isTimeout { // timeout.
                        if !task.isAsync && self?.syncWaitingTask != nil && self?.syncWaitingTask == task {
                            self?.syncWaitingTask = nil
                            self?.removeTask(task: task, isAsync: task.isAsync)
                            self?.isTasking = false
                            self?.execute() //next task.
                        } else {
                            //check async waiting tasks.
                            self?.asyncWaitingTasksLock.lock()
                            self?.asyncWaitingTasks.remove(task)
                            self?.asyncWaitingTasksLock.unlock()
                        }
                    } else {
                        self?.removeTask(task: task, isAsync: task.isAsync)
                    }
                }
                
                //add task.
                let temTasks = task.isAsync ? self.asyncTasks : self.tasks
                temTasks.add(task)
                self.lock.unlock()
            }
        }
    }
    
    func removeTask(task:BLETask?, isAsync: Bool = false) {
        let temTasks = isAsync ? self.asyncTasks : self.tasks
        DispatchQueue.global().async {
            self.lock.lock()
            if let task = task {
                temTasks.remove(task)
            }
            self.lock.unlock()
        }
    }
    
    func getTask(isAsync: Bool = false) -> BLETask? {
        var maxPriorityTask:BLETask?
        let temTasks = isAsync ? self.asyncTasks : self.tasks
        DispatchQueue.global().sync {
            self.lock.lock()
            if temTasks.count == 0 {
                self.lock.unlock()
                return
            }
            
            for index in 0...(temTasks.count - 1) {
                let tModel = temTasks[index] as! BLETask
                if maxPriorityTask == nil {
                    maxPriorityTask = tModel
                } else {
                    if tModel.priority.rawValue > maxPriorityTask!.priority.rawValue {
                        maxPriorityTask = tModel
                    }
                }
            }
            self.lock.unlock()
        }
        print("==================current tasks count: ", temTasks.count)
        return maxPriorityTask
    }
    
    func removeAllTasks() {
        DispatchQueue.global().async {
            self.lock.lock()
            for task in self.tasks {
                let temTask = task as! BLETask
                temTask.resonseBlock?([BLEConstants.STATE: BLETaskState.cancel, BLEConstants.MESSAGE:"Cancel."])
            }
            self.tasks.removeAllObjects()
            
            for task in self.asyncTasks {
                let temTask = task as! BLETask
                temTask.resonseBlock?([BLEConstants.STATE: BLETaskState.cancel, BLEConstants.MESSAGE:"Cancel."])
            }
            self.asyncTasks.removeAllObjects()
            self.lock.unlock()
        }
    }
}

extension BLETasksCenter {
    
    func didReceiveDataFrom(characteristic: CBCharacteristic, error: Error?) {
        let service = characteristic.service?.uuid.uuidString
        let uuid = characteristic.uuid.uuidString
        
        //check sync waitting task.
        if self.syncWaitingTask != nil && self.syncWaitingTask!.resonseServerUUID != nil && self.syncWaitingTask!.resonseCharacteristic != nil {
            if (self.syncWaitingTask!.resonseServerUUID! == service) && (self.syncWaitingTask!.resonseCharacteristic! == uuid) {
                self.syncWaitingTask?.resonseData = characteristic.value
                self.writeWithResonseTaskFinished(state:(error == nil ? BLETaskState.success : BLETaskState.fail), task:self.syncWaitingTask!, error: error)
            }
        }
        
        //check async waiting tasks.
        self.asyncWaitingTasksLock.lock()
        let tTasks = self.getTasksByServiceAndCha(service: service ?? "", cha: uuid, from: self.asyncWaitingTasks as! Array<Any>)
        for task in tTasks {
            let iTask = task as! BLETask
            iTask.resonseData = characteristic.value
            self.writeWithResonseTaskFinished(state:(error == nil ? BLETaskState.success : BLETaskState.fail), task:iTask, error: error)
            self.asyncWaitingTasks.remove(task)
        }
        self.asyncWaitingTasksLock.unlock()
    }
    
    func NULL_DATA() -> Data {
        return Data(bytes: [], count: 0)
    }
    
    func getTasksByServiceAndCha(service:String, cha: String, from aTasks:Array<Any>) -> NSMutableArray {
        let tTasks = NSMutableArray()
        for tem in aTasks {
            let iTem = tem as! BLETask
            if iTem.resonseServerUUID == service && iTem.characteristic == cha {
                tTasks.add(tem)
            }
        }
        return tTasks
    }
}
