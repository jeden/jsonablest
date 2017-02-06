//: Playground - noun: a place where people can play

import UIKit


//import Jsonablest

func curried2(_ param1: Int, _ param2: Int) -> Int {
	return param1 + param2
}

func curried3(_ param1: Int, _ param2: Int, _ param3: Int) -> Int {
	return param1 + param2 + param3
}

func curried4(_ param1: Int, _ param2: Int, _ param3: Int, _ param4: Int) -> Int {
	return param1 + param2 + param3 + param4
}

infix operator <&&> : TernaryPrecedence
infix operator <||> : TernaryPrecedence
infix operator <^> : AssignmentPrecedence

func <&&><A, B>(_ op1: A?, op2: B?) -> (A, B)? {
	guard let a = op1, let b = op2 else { return .none }
	return (a, b)
}

func <&&><A, B, C>(_ op1: A?, _ op2: (B? , C?)) -> (A, B, C)? {
	guard let a = op1 else { return .none }
	guard let b = op2.0, let c = op2.1 else { return .none }
	return (a, b, c)
}

func <&&><A, B, C, D>(_ op1: A?, _ op2: (B? , (C?, D?))) -> (A, B, C, D)? {
	guard let a = op1 else { return .none }
	guard let b = op2.0  else { return .none }
	guard let c = op2.1.0, let d = op2.1.1 else { return .none }
	return (a, b, c, d)
}

func <^><A, B, Z>(_ f: (A, B) -> (Z), _ op: (A, B)?) -> Z? {
	guard let op = op else { return .none }
	return f(op.0, op.1)
}

func <^><A, B, C, Z>(_ f: (A, B, C) -> (Z), _ op: (A, (B, C))?) -> Z? {
	guard let op = op else { return .none }
	let a = op.0
	let b = op.1.0
	let c = op.1.1
	return f(a, b, c)
}

func <^><A, B, C, D, Z>(_ f: (A, B, C, D) -> (Z), _ op: (A, (B, (C, D)))?) -> Z? {
	guard let op = op else { return .none }
	let a = op.0
	let b = op.1.0
	let c = op.1.1.0
	let d = op.1.1.1
	return f(a, b, c, d)
}

10 <&&> 11
curried2 <^> 10 <&&> 11

10 <&&> 11 <&&> 12
curried3 <^> 10 <&&> 11 <&&> 12
curried3 <^> nil <&&> 11 <&&> 12
curried3 <^> 10 <&&> nil <&&> 12
curried3 <^> 10 <&&> 11 <&&> nil

10 <&&> 11 <&&> 12 <&&> 13
curried4 <^> 10 <&&> 11 <&&> 12 <&&> 13
curried4 <^> nil <&&> 11 <&&> 12 <&&> 13
curried4 <^> 10 <&&> nil <&&> 12 <&&> 13
curried4 <^> 10 <&&> 11 <&&> nil <&&> 13
curried4 <^> 10 <&&> 11 <&&> 12 <&&> nil


