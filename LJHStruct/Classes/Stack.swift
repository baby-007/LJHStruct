//
//  Stack.swift
//  NTest
//
//  Created by liaoJian lakdf on 2020/1/14.
//  Copyright © 2020 liaoJian lakdf. All rights reserved.
//

import Foundation
struct Stack<T> {
    class StackNode {
        var value: T
        var next: StackNode?
        init(_ _value: T) {
            value = _value
        }
    }
    private var first: StackNode?
    private(set) var count: Int = 0
    //入栈
    mutating func push(_ value: T) {
        let newNode = StackNode(value)
        newNode.next = first
        first = newNode
        count += 1
    }
    //出栈
    mutating func pop() -> T? {
        guard count > 0 else {
            return nil
        }
        let value = first?.value
        first = first?.next
        count -= 1
        return value
    }
    func peak() -> T? {
        return first?.value
    }
    func peak2() -> T? {
        return first?.next?.value
    }
    //清空
    mutating func clear() {
        first = nil
        count = 0
    }
}

//特殊栈
struct Stack1<T> {
    class StackNode {
        var value: T
        var next: StackNode?
        init(_ _value: T) {
            value = _value
        }
    }
    private var first: StackNode?
    private var prev: StackNode?
    private var current: StackNode?
    private(set) var count: Int = 0
    //入栈
    mutating func push(_ value: T) {
        let newNode = StackNode(value)
        newNode.next = first
        first = newNode
        count += 1
    }
    //出栈
    mutating func pop() -> T? {
        guard count > 0 else {
            return nil
        }
        let value = first?.value
        first = first?.next
        count -= 1
        return value
    }
    
    mutating func resetCurrent() {
        
    }
    mutating func popCurrent() -> T? {
        if let curr = current {
            if let _prev = prev {
                _prev.next = curr.next
            } else {
                first = curr.next
            }
            count -= 1
            return curr.value
        }
        return nil
    }
//    func peak() -> T? {
//        return first?.value
//    }
    mutating func peakNext() -> T? {
        if current == nil {
            current = first
            prev = nil
        } else {
            prev = current
        }
        
        let value = current?.value
        current = current?.next
        return value
    }
    mutating func currentToFirst() {
        current = first
        prev = nil
    }
    //清空
    mutating func clear() {
        first = nil
        count = 0
    }
}
