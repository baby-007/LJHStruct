//
//  RBTree.swift
//  NTest
//
//  Created by liaoJian lakdf on 2020/1/13.
//  Copyright © 2020 liaoJian lakdf. All rights reserved.
//

import Foundation

class RBTree<T: Comparable>: NSObject {

    var count: Int = 0
    var root: RBNode?
    static var RED: Bool {return false}
    static var BLACK: Bool {return true}
    var comparator: Comparator?
    class RBNode: NSObject {
        var parent: RBNode?
        var left: RBNode?
        var right: RBNode?
        var color: Bool = RBTree.RED
        var value: T
        init(_value: T) {
            value = _value
            super.init()
        }
    }
    @discardableResult func add(value: T) -> Bool {
        let oldCount = realCount()
        let newNode = RBNode(_value: value)
        let isAdd = add(node: newNode)
        if isAdd {
            count += 1
        }
        let newCount = realCount()
        let addCount = newCount - oldCount
        let condition = (newCount == count) && (isAdd ? addCount == 1 : addCount == 0)
        assert(condition, "添加错误")
        print("\(newCount)")
        checkParent()
        checkBlackCount()
        return isAdd
    }
    func compare(_ t1: T, _ t2: T) -> ComparisonResult {
        if let _comparator = comparator {
            return _comparator(t1, t2)
        }
        if t1 > t2 {
            return .orderedDescending
        } else if t1 < t2 {
            return .orderedAscending
        } else {
            return .orderedSame
        }
    }
    //MARK: 添加
    @discardableResult func add(node: RBNode) -> Bool {
        if root == nil {
            beBlack(node)
            root = node
            return true
        }
        var findNode = root
        var finded = root
        var isRight = false
        repeat {
            finded = findNode
            let result = compare(node.value, findNode!.value)
            if result == .orderedDescending {
                isRight = true
                findNode = findNode!.right
            } else if result == .orderedAscending {
                isRight = false
                findNode = findNode!.left
            } else {
                return false
            }
        } while findNode != nil
        
        if isRight {
            finded!.right = node
        } else {
            finded!.left = node
        }
        node.parent = finded
        
        fixAfterAdd(node: node)
        return true
    }
    //MARK: 查找
    func getNode(value: T) -> RBNode? {
        var node = root
        while let _node = node {
            let result = compare(value, _node.value)
            if result == .orderedDescending {
                node = _node.right
            } else if result == .orderedAscending {
                node = _node.left
            } else {
                return node
            }
        }
        return nil
    }
    //MARK:包含
    func contain(value: T) -> Bool {
        return getNode(value: value) != nil
    }
    
    //MARK: 删除最复杂的接口
    @discardableResult func remove(value: T) -> Bool {
        //存在后继的话实际删除的是后继节点
        //后继节点的度!=2
        defer {
            checkParent()
            checkBlackCount()
        }
        guard var node = getNode(value: value) else {
            NSLog("删除不存在 \(value)")
            return false
        }
        count -= 1
        var entrance = false
        if node.left != nil && node.right != nil {
            if let removeNode = successor(node: node) {
                node.value = removeNode.value
                node = removeNode
            }
        }
//        var replacement: RBNode?
        //此时node的度!=2
        assert(node.left == nil || node.right == nil, "方法successor错误")
        if let replace = node.left, node.right == nil {
            //左替换node
            //node 必然为黑色 否则不满足性质
//            replacement = replace
            if isLeft(node) {
                node.parent?.left = replace
            } else {
               node.parent?.right = replace
            }
            replace.parent = node.parent
            if replace.parent == nil {
                root = replace
            }
            //染色
//            reColor(replace, node.color)
            node.parent = nil
            node.left = nil
            node = replace
        } else if node.left == nil, let replace = node.right {
            //右替换node
            //node 必然为黑色
//            replacement = replace
            if isLeft(node) {
                node.parent?.left = replace
            } else {
               node.parent?.right = replace
            }
            replace.parent = node.parent
            if replace.parent == nil {
                root = replace
            }
            //染色
//            reColor(replace, node.color)
            node.parent = nil
            node.right = nil
            node = replace
        } else if node.parent == nil  {
            //且删除的为根节点
            root = nil
            return true
        } else if node.color == Self.RED {
            //左右皆为空 且删除的为红色
            //直接删
            if isLeft(node) {
                node.parent?.left = nil
            } else {
               node.parent?.right = nil
            }
            node.parent = nil
            return true
        }  else {
            //左右皆为空 且删除的为黑色
            entrance = true
        }
//        //如果替代的节点为红色 必然没有叶子
        fixAfterRemove(node: node, entrance: entrance)
        return true
    }
    //MARK: 删除后的修复
    //node 删除的节点或者用于替换的节点
    //entrance 是否作为删除入口
    func fixAfterRemove(node: RBNode, entrance: Bool) {
        //删除的为黑色节点
        
        if node.color == Self.RED || node.parent == nil {
            //若替换者为红 或根节点 染黑即可
            beBlack(node)
            return
        }
        //没有替换者 或 替换者为黑
        var _brother = brother(node)
        let isLeftNode = isLeft(node)
        let parent = node.parent
        if entrance {
            //删除入口进入的红色叶子节点
            if isLeft(node) {
                node.parent?.left = nil
            } else {
               node.parent?.right = nil
            }
            node.parent = nil
        }
        if _brother?.color == Self.RED {
            //兄弟为红色
            //通过旋转转化为兄弟为黑色
            if isLeftNode {
                beBlack(_brother)
                beRed(parent)
                rotateLeft(parent)
                _brother = parent?.right
            } else {
                //被删除的节点在右边兄弟在左边
                //父节点右旋
                //兄弟变黑父节点变红
                beBlack(_brother)
                beRed(parent)
                rotateRight(parent)
                _brother = parent?.left
            }
        }
        //此时兄弟必然为黑 因为空也是黑
        //若兄弟节点存在红子节点则通过旋转向兄弟
        //借节点已达到平衡
        //若兄弟没有红色子节点 & 父节点为黑色 则父节点向下合并（下溢）
        //若兄弟没有红色子节点 & 父节点为红色 则父节点变黑 兄弟变红
        if _brother?.left?.color == Self.RED || _brother?.right?.color == Self.RED {
            if isLeftNode {
                if _brother?.right?.color != Self.RED {
                    let newBrother = _brother?.left
                    rotateRight(_brother)
                    _brother = newBrother
                }
                let pColor = parent?.color ?? Self.BLACK
                rotateLeft(parent)
                reColor(_brother, pColor)
                beBlack(_brother?.right)
                beBlack(_brother?.left)
            } else {
                if _brother?.left?.color != Self.RED {
                    let newBrother = _brother?.right
                    rotateLeft(_brother)
                    _brother = newBrother
                }
                let pColor = parent?.color ?? Self.BLACK
                rotateRight(parent)
                reColor(_brother, pColor)
                beBlack(_brother?.left)
                beBlack(_brother?.right)
            }
        } else {
            if parent?.color == Self.RED {
                beBlack(parent)
                beRed(_brother)
            } else if let p = parent {
                beRed(_brother)
                fixAfterRemove(node: p, entrance: false)
            }
        }
    }
    //MARK: 后继（比当前节点"大的最小"的节点）
    func successor(node: RBNode) -> RBNode? {
        //首先明确度为2的节点必然存在后继
        var right = node.right
        if right != nil {
            //情况1：node存在右子树
            //则后继为右子树的最小节点
            var find: RBNode?
            repeat {
                find = right
                right = right?.left
            } while right != nil
            return find
        }  else {
            //情况2：无右子树 & 为根节点 & 没有右子树
            //没有后继
            //情况3：无右子树 & 存在父节点 & 往父节点追溯可以找到某一个祖先节点为其父节点的左孩子
            //则存在后继
            //情况4：无右子树 & 存在父节点 & 往父节点追溯不可以找到某一个祖先节点为其父节点的左孩子
            //则不存在后继
            var parent: RBNode? = node
            while parent != nil && !isLeft(parent) {
                parent = parent?.parent
            }
            return parent?.parent
        }
    }
    
    //MARK: 前序遍历
    func prevOder(vistor: ((T) -> Bool), node: RBNode? = nil) {
        guard let _node = node else {return }
        if !vistor(_node.value) {
            prevOder(vistor: vistor, node: _node.left)
            prevOder(vistor: vistor, node: _node.right)
        }
    }
    //MARK: 中序遍历
    func inOder(vistor: ((T) -> Bool), node: RBNode? = nil) {
        guard let _node = node else {return }
        inOder(vistor: vistor, node: _node.left)
        if vistor(_node.value) {return }
        inOder(vistor: vistor, node: _node.right)
    }
    //MARK: 后序遍历
    func postOder(vistor: ((T) -> Bool), node: RBNode? = nil) {
        guard let _node = node else {return }
        postOder(vistor: vistor, node: _node.left)
        postOder(vistor: vistor, node: _node.right)
        if vistor(_node.value) {return }
    }
    //MARK: 层序遍历
    func sequenceOder(vistor: ((T) -> Bool), node: RBNode? = nil) {
        guard let _node = node else {return }
        
        var queue = Queue<RBNode>()
        queue.push(_node)
        while queue.count > 0 {
            //遍历
            guard let _newNode = queue.pop() else {return }//遍历完成
            if vistor(_newNode.value) {return }
            if let _left = _newNode.left {
                queue.push(_left)
            }
            if let _right = _newNode.right {
                queue.push(_right)
            }
        }
    }
    
    func realCount() -> Int {
        var allCount: Int = 0
        guard let _node = root else {return allCount}
        
        var stack = Stack<RBNode>()
        stack.push(_node)
        while stack.count > 0 {
            //遍历
            let _newNode = stack.pop()
            if _newNode != nil {
                allCount += 1
            }
            if let _left = _newNode?.left {
                stack.push(_left)
            }
            if let _right = _newNode?.right {
                stack.push(_right)
            }
        }
        return allCount
    }
    func checkParent() {
        guard let _node = root else {return}
        
        var stack = Stack<RBNode>()
        stack.push(_node)
        while stack.count > 0 {
            //遍历
            let _newNode = stack.pop()
            if _newNode != nil {
                rightParent(_newNode!)
            }
            if let _left = _newNode?.left {
                stack.push(_left)
            }
            if let _right = _newNode?.right {
                stack.push(_right)
            }
        }
    }
    func checkBlackCount() {
        guard let _node = root else {return}
        
        var blackCount: Int = -1
        var stack = Stack<RBNode>()
        stack.push(_node)
        while stack.count > 0 {
            //遍历
            let _newNode = stack.pop()
            var newCount: Int = 0
            if _newNode?.left == nil || _newNode?.right == nil {
                var new = _newNode
                while new != nil {
                    if new?.color == Self.BLACK {
                        newCount += 1
                    } else {
                        assert(new?.parent?.color != Self.RED, "节点颜色错误")
                    }
                    new = new?.parent
                }
                if blackCount == -1 {
                    blackCount = newCount
                } else {
                    assert(blackCount == newCount, "黑节点数量错误")
                    blackCount = newCount
                }
            }
            if let _left = _newNode?.left {
                stack.push(_left)
            }
            if let _right = _newNode?.right {
                stack.push(_right)
            }
        }
    }
    func rightParent(_ node: RBNode) {
        guard let parent = node.parent else {return }
        assert(node == parent.left || node == parent.right, "父节点错误")
    }
    func sequencePrint() {
        guard let _node = root else {return }
        
        var stack = Queue<RBNode>()
        stack.push(_node)
        var sequence = [RBNode]()
        
        while stack.count > 0 {
            //遍历
            var prin = ""
            while stack.count > 0 {
                if let _newNode = stack.pop() {
                    let p = _newNode.parent
                    let str = (p?.value as? String) ?? String(describing: p?.value)
                    prin += "\(_newNode.value)" + (_newNode.color == Self.RED ? "_R" : "_B")
                        + (p == nil ? "根" : "_父\(str)") + (stack.count == 0 ? "" : ", ")
                    sequence.append(_newNode)
                }
            }
            print("\(prin)")
            for n in sequence {
                if let _left = n.left {
                    stack.push(_left)
                }
                if let _right = n.right {
                    stack.push(_right)
                }
            }
            sequence.removeAll()
        }
    }
    //MARK: 修复红黑树性质
    func fixAfterAdd(node: RBNode) {
        guard node != root else {
            beBlack(node)
            return
        }
        //双红才需要修复
        guard node.color == (node.parent?.color ?? Self.BLACK) && node.color == Self.RED else {
            return
        }
        
        let parent = node.parent
        let grand = parent?.parent
        let _uncle: RBNode?
        var parentIsRight: Bool = true
        if grand == nil {
            _uncle = nil
        } else if node.parent == grand?.left {
            _uncle = grand?.right
            parentIsRight = false
        } else {
            _uncle = grand?.left
        }
        //能到这里grand不可能为nil
        if color(_uncle) == Self.BLACK {
            //1: 叔叔为黑色
            //父亲为右孩子
            if parentIsRight {
                //自己为父亲的右孩子
                beRed(grand)
                if isRight(node) {
                    //父亲染黑 祖父染红 祖父左旋
                    beBlack(parent)
                } else {
                    //自己染黑 祖父染红 父亲右旋 祖父左旋
                    beBlack(node)
                    rotateRight(parent)
                }
                rotateLeft(grand)
            } else {
                //父亲为左孩子 对称操作
                beRed(grand)
                if isLeft(node) {
                    beBlack(parent)
                } else {
                    beBlack(node)
                    rotateLeft(parent)
                }
                rotateRight(grand)
            }
        } else {
            //2: 叔叔为红色
            //祖父染红 父亲和叔叔染黑 祖父左右新加入节点递归
            //这里如果新加入的节点为叶子节点
            //如采用 “叔叔为黑色”的处理方法会出现 叔叔和祖父的双红错误
            //综上 我认为这里不能采用 “叔叔为黑色”的处理
            beBlack(_uncle)
            beBlack(parent)
            beRed(grand)
            if let _grand = grand {
                fixAfterAdd(node: _grand)
            }
        }
    }
    func uncle(_ node: RBNode) -> RBNode? {
        guard let grand = grandFather(node) else {return nil}
        if node.parent == grand.left {
            return grand.right
        } else {
            return grand.left
        }
    }
    func grandFather(_ node: RBNode) -> RBNode? {
        return node.parent?.parent
    }
    func brother(_ node: RBNode) -> RBNode? {
        if isLeft(node) {
            return node.parent?.right
        } else {
            return node.parent?.left
        }
    }
    func color(_ node: RBNode?) -> Bool {
        guard let _node = node else {return Self.BLACK}
        return _node.color
    }
    func isRight(_ node: RBNode?) -> Bool {
        guard let _node = node else {return false}
        return _node == _node.parent?.right
    }
    func isLeft(_ node: RBNode?) -> Bool {
        guard let _node = node else {return false}
        return _node == _node.parent?.left
    }

    func rotateLeft(_ node: RBNode?) {
        guard let _node = node, let theRight = _node.right else {
            return
        }
        let theNewRight = theRight.left
        if isLeft(_node) {
            _node.parent?.left = theRight
        } else {
            _node.parent?.right = theRight
        }
        theRight.parent = _node.parent
        theRight.left = _node
        if theRight.parent == nil {
            //node为根节点
            root = theRight
        }
        theNewRight?.parent = _node
        _node.right = theNewRight
        _node.parent = theRight
    }
    func rotateRight(_ node: RBNode?) {
        guard let _node = node, let theLeft = _node.left else {return }
        let newLeft = theLeft.right
        if isLeft(_node) {
            _node.parent?.left = theLeft
        } else {
            _node.parent?.right = theLeft
        }
        theLeft.right = _node
        theLeft.parent = _node.parent
        if theLeft.parent == nil {
            root = theLeft
        }
        newLeft?.parent = _node
        _node.left = newLeft
        _node.parent = theLeft
    }
    
    //MARK: 染色
    func beRed(_ node: RBNode?) {
        node?.color = Self.RED
    }
    func beBlack(_ node: RBNode?) {
        node?.color = Self.BLACK
    }
    func reColor(_ node: RBNode?, _ color: Bool) {
        node?.color = color
    }
}
