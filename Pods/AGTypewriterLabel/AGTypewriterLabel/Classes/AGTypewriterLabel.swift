//
//  AGTypewriterLabel.swift
//  AGTypewriterLabel
//  The MIT License (MIT)
//  Copyright © 2018 Aivant Goyal 1/09/18.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files
//  (the “Software”), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software,
//  and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

public protocol AGTypewriterLabelDelegate{
    func didFinishAnimating(label: AGTypewriterLabel)
}

public enum AGTypewriterAnimation {
    case text(string: String, interval: TimeInterval)
    case pause(length:TimeInterval)
}

public class AGTypewriterLabel: UILabel {
    
    public var delegate : AGTypewriterLabelDelegate?
    private var defaultCharInterval : TimeInterval = 0.1
    private var animations = [AGTypewriterAnimation]()
    private let dispatchQueue = DispatchQueue(label: "AGTypewriterLabelQueue")
    
    override public var text : String! {
        get {
            return super.text
        }
        set {
            addAnimation(.text(string: newValue, interval: defaultCharInterval))
        }
    }
    
    public func addAnimation(_ animation: AGTypewriterAnimation){
        self.animations.append(animation)
    }
    
    public func addAnimations(_ animations: [AGTypewriterAnimation]){
        self.animations.append(contentsOf: animations)
    }
    
    public func clearAnimations(){
        self.animations.removeAll()
    }
    
    public func startAnimation(){
        super.text = ""
        animate()
    }
    
    private func animate(){
        guard animations.count > 0 else {
            delegate?.didFinishAnimating(label: self)
            return
        }
        let animation = animations.removeFirst()
        switch animation{
            case let .text(string, interval):
                type(text: string, withInterval: interval)
            case let .pause(length):
                pause(forSeconds: length)
        }
    
    }
    
    private func pause(forSeconds seconds : TimeInterval){
        DispatchQueue.main.async {
            self.dispatchQueue.asyncAfter(deadline: .now() + seconds, execute: { [weak self] in
                self?.animate()
                return
            })
        }
    }
    
    private func type(text: String, withInterval interval: TimeInterval) {
        DispatchQueue.main.async {
            guard let nextChar = text.first else {
                self.animate()
                return
            }
            
            super.text = super.text! + String(nextChar)
            self.sizeToFit()
            
            self.dispatchQueue.asyncAfter(deadline: .now() + interval, execute: { [weak self] in
                self?.type(text: String(text.dropFirst()), withInterval: interval)
            })
        }
    }

}
