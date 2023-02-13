//
//  PrintTree.swift
//  NTest
//
//  Created by liaoJian lakdf on 2020/1/16.
//  Copyright © 2020 liaoJian lakdf. All rights reserved.
//

import Foundation
class PrintTree {
//    static func printTree(_ tree: RBTree<String>) {
//        guard let _node = tree.root else {return }
//
//        func valueCount(_ n: RBTree<String>.RBNode) -> Int {
//            return n.value.count + 1
//        }
//
//        var stack = Queue<RBTree<String>.RBNode>()
//        stack.push(_node)
//        var sequence = [RBTree<String>.RBNode]()
//        var allNode = [[RBTree<String>.RBNode]]()
//        var maxLen: Int = 0
//        var maxCount: Int = 0
//        var bWidth: Int = 0
//        while stack.count > 0 {
//            //遍历
////            var prin = ""
//            while stack.count > 0 {
//                if let _newNode = stack.pop() {
////                    prin += "\(_newNode.value)" + (stack.count == 0 ? "" : ", ")
//                    sequence.append(_newNode)
//
//                    if valueCount(_newNode) > maxLen {
//                        maxLen = valueCount(_newNode)
//                    }
//                }
//                if sequence.count > maxCount {
//                    maxCount = sequence.count
//                }
////                var q = [RBTree<String>.RBNode]()
////                q.append(contentsOf: sequence)
//            }
//            allNode.append(sequence)
////            print("\(prin)")
//            for n in sequence {
//                if let _left = n.left {
//                    stack.push(_left)
//                }
//                if let _right = n.right {
//                    stack.push(_right)
//                }
//            }
//            sequence.removeAll()
//        }
////        maxLen *= 2
//        guard allNode.count > 0 else {return }
//        var realB = maxLen + bWidth * 2
//        func width(_ count: Int) -> Int {
//            return count * maxLen
//        }
//        func valueString(_ n: RBTree<String>.RBNode) -> String {
//            let str = n.value + (n.color == RBTree<String>.RED ? "R" : "B")
//            let spaceC = (maxLen - str.count) / 2
//            var addStr = ""
//            for _ in 0..<spaceC {
//                addStr += " "
//            }
//            return addStr + str + addStr
//        }
//
//        let maxWidth = width(maxCount)
//        let fNodes = allNode[0]
//        let firstX = (maxWidth - width(fNodes.count)) / 2
//
//        var beginX = firstX
//        for i in 0..<fNodes.count {
//            fNodes[i].x = beginX
//            beginX += maxLen
//        }
//        for i in 1..<allNode.count {
//            let nodes = allNode[i]
//            for node in nodes {
//                if let p = node.parent {
//                    if node == p.left {
//                        node.x = p.x - maxLen
//                    } else {
//                        node.x = p.x + maxLen
//                    }
//                } else {
//                    assert(false, "x计算错误")
//                }
//            }
//        }
//        //打印
//        for nodes in allNode {
//            //nodes在同 层
//            var spaceCount: Int = 0
//            var printStr = ""
//            var nn1 = nodes
//            let nn = nodes.sorted(by: {$0.x < $1.x})
//            for node in nn {
//                var curLen = node.x - spaceCount
//                curLen = max(0, curLen)
//                for _ in 0..<curLen {
//                    printStr += " "
//                }
//                printStr += valueString(node)
//                spaceCount = curLen + valueCount(node)
//            }
//            print("\(printStr)")
//        }
//    }
}
