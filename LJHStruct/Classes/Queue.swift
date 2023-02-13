//
//  Queue.swift
//  NTest
//
//  Created by liaoJian lakdf on 2020/1/15.
//  Copyright © 2020 liaoJian lakdf. All rights reserved.
//

import Foundation
struct Queue<T> {
    class QueueNode {
        var value: T
        var next: QueueNode?
        var prev: QueueNode?
        init(_ _value: T) {
            value = _value
        }
    }
    private var first: QueueNode?
    private var last: QueueNode?
    private(set) var count: Int = 0
    
    mutating func push(_ value: T) {
        let newNode = QueueNode(value)
        last?.next = newNode
        newNode.prev = last
        
        last = newNode
        count += 1
        if first == nil {
            first = newNode
        }
    }
    mutating func pop() -> T? {
        guard count > 0 else {return nil}
        let value = first?.value
        let next = first?.next
        first?.next = nil
        first?.next?.prev = nil
        first = next
        count -= 1
        if count == 0 {
            last = nil
        }
        return value
    }
    func firstValue() -> T? {
        return first?.value
    }
    func lastValue() -> T? {
        return last?.value
    }
    //清空
    mutating func clear() {
        var node = first
        while let _node = node {
            node = _node.next
            _node.next = nil
            _node.prev = nil
        }
        first = nil
        last = nil
        count = 0
    }
}


