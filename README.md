# BKStackLayout

<div align="center">
	<img src="https://img.shields.io/badge/iOS-%3E%3D%209.0-green.svg" />
	<img src="https://img.shields.io/badge/OSX-%3E%3D%2010.11-green.svg" />
	<img src="https://img.shields.io/badge/Swift-%3E%3D%204.2-orange.svg" />
	<img src="https://img.shields.io/cocoapods/v/BKStackLayout.svg" />
	<img src="https://img.shields.io/github/license/ReactComponentKit/BKStackLayout.svg" />
</div>

BKStackLayout is a tiny utility library wrapping UIStackView or NSStackView.

## How to install

```
pod 'BKStackLayout'
```

## Example

![](./art/shot.png)

```swift
StackLayout.vertical {
    $0.vertical {
        $0.add(views: [
            self.label1,
            $0.fixed(h: 100, bgColor: .green),
            self.label2,
            $0.fixed(h: 20, bgColor: .magenta)
        ]).align(horizontal: .fill).distribute(.fill).spacing(20)
    }
    
    $0.horizontal {
        $0.add(views: [$0.flex(), $0.wrap(self.label4, w: 200), $0.flex(), $0.fixed(w: 100, bgColor: .red)])
        $0.align(vertial: .top)
        $0.spacing(10)
        $0.distribute(.fill)
    }
    
    $0.horizontal {
        $0.add(views: [self.label3]).distribute(.fill)
    }
    
    $0.align(horizontal: .fill)
    $0.spacing(30)
}
```

## MIT License

The MIT License

Copyright © 2018 Sungcheol Kim, https://github.com/ReactComponentKit/BKStackLayout

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
