//
//  NSLayoutConstraint+.swift
//  CollectionX
//
//  Created by Yevhenii on 03.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

extension NSLayoutConstraint {

    func deactivated() -> NSLayoutConstraint {
        self.isActive = false
        return self
    }

    func activated() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }

}


precedencegroup ConstraintPrecedence {
  associativity: left
  higherThan: MultiplicationPrecedence
}

//infix operator <---: ConstraintPrecedence
//infix operator <~~~: ConstraintPrecedence
//infix operator --->: ConstraintPrecedence
//infix operator --<=: ConstraintPrecedence
//infix operator -->=: ConstraintPrecedence
//infix operator ---=: ConstraintPrecedence
infix operator ↑↑: ConstraintPrecedence
infix operator ↓↓: ConstraintPrecedence
infix operator ↑↓: ConstraintPrecedence
infix operator →→: ConstraintPrecedence
infix operator →←: ConstraintPrecedence
infix operator ←←: ConstraintPrecedence
infix operator ←→: ConstraintPrecedence

infix operator ←==→: ConstraintPrecedence

//@discardableResult
//func <--- <T> (lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
//    return rhs.constraint(equalTo: lhs).activated()
//}
//
//@discardableResult
//func ---> <T> (lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
//    return lhs.constraint(equalTo: rhs).activated()
//}
//
//@discardableResult
//func --<= <T> (lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
//    return lhs.constraint(lessThanOrEqualTo: rhs).activated()
//}
//
//@discardableResult
//func -->= <T> (lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
//    return lhs.constraint(greaterThanOrEqualTo: rhs).activated()
//}
//
//@discardableResult
//func ---= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
//    return lhs.constraint(equalToConstant: rhs)
//}

func ↑↑ (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.top, to: rhs.top)
}

func ↓↓ (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.bottom, to: rhs.bottom)
}

func ↑↓ (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.top, to: rhs.bottom)
}

func →→ (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.trailing, to: rhs.trailing)
}

func ←← (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.leading, to: rhs.leading)
}

func ←→ (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.leading, to: rhs.trailing)
}

func →← (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.pin(.trailing, to: rhs.leading)
}

func ←==→ (lhs: UIView, rhs: UIView) -> NSLayoutConstraint {
    return lhs.width(equalTo: rhs.width)
}

@discardableResult
func + (lhs: NSLayoutConstraint, rhs: CGFloat) -> NSLayoutConstraint {
    lhs.constant = rhs
    return lhs
}

@discardableResult
func - (lhs: NSLayoutConstraint, rhs: CGFloat) -> NSLayoutConstraint {
    lhs.constant = -rhs
    return lhs
}
