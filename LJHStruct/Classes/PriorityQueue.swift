//
//  PriorityQueue.swift
//  LJHTest
//
//  Created by liaoJian lakdf on 2020/1/17.
//  Copyright © 2020 liaoJian lakdf. All rights reserved.
//

import Foundation
//MARK: 优先级队列
struct PriorityQueue<T: Comparable> {
    private var queue = [T]()
    private(set) var count: Int = 0
    private(set) var bigTop: Bool //默认大顶堆
    init(_ _bigTop: Bool = true) {
        bigTop = _bigTop
    }
    //MARK: 入队
    mutating func offer(_ value: T) {
        count += 1
        queue.append(value)
        if count > 1 {
            siftUp(index: count - 1)
        }
    }
    func peak() -> T? {
        guard count > 0 else {return nil}
        return queue[0]
    }
    //MARK: 出队
    mutating func poll() -> T? {
        guard count > 0 else {return nil}
        let value = queue[0]
        queue[0] = queue[count - 1]
        queue.remove(at: count - 1)
        count -= 1
        if count > 1 {
            siftDown(index: 0)
        }
        return value
    }
    //MARK: 批量建堆
    mutating func heapfiy(_ array: [T]) {
        count = array.count
        queue = Array.init(array)
        //从最后一个度不等于0的节点开始
        //做自下而上的下虑
        var i: Int = count >> 1 - 1
        while i >= 0 {
            siftDown(index: i)
            i -= 1
        }
    }
    //MARK: 上虑
    mutating func siftUp(index: Int) {
        var _index = index
        var pIndex = (index - 1) >> 1
        let value = queue[index]
        if bigTop {
            while pIndex >= 0 {
                if value > queue[pIndex] {
                    queue[_index] = queue[pIndex]
                } else {
                    break
                }
                _index = pIndex
                pIndex = (pIndex - 1) >> 1
            }
            queue[_index] = value
        } else {
            while pIndex >= 0 {
                if value < queue[pIndex] {
                    queue[_index] = queue[pIndex]
                } else {
                    break
                }
                _index = pIndex
                pIndex = (pIndex - 1) >> 1
            }
            queue[_index] = value
        }
    }
    
    
    //MARK: 下虑
    mutating func siftDown(index: Int) {
        var _index = index
        let value = queue[_index]
        var leftIndex = _index << 1 + 1
        var rightIndex = _index << 1 + 2
        var selectIndex = leftIndex
        if bigTop {
            while leftIndex < count {
                if rightIndex < count, queue[rightIndex] > queue[leftIndex], queue[rightIndex] > value {
                    selectIndex = rightIndex
                } else if queue[leftIndex] > value {
                    selectIndex = leftIndex
                } else {
                    break
                }
                queue[_index] = queue[selectIndex]
                _index = selectIndex
                leftIndex = _index << 1 + 1
                rightIndex = _index << 1 + 2
            }
            queue[_index] = value
        } else {
            while leftIndex < count {
                if rightIndex < count, queue[rightIndex] < queue[leftIndex], queue[rightIndex] < value {
                    selectIndex = rightIndex
                } else if queue[leftIndex] < value {
                    selectIndex = leftIndex
                } else {
                    break
                }
                queue[_index] = queue[selectIndex]
                _index = selectIndex
                leftIndex = _index << 1 + 1
                rightIndex = _index << 1 + 2
            }
            queue[_index] = value
        }
    }
}
