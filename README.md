# HBToast
---
Swift 版的 toast 控件

简易的 API 调用:

```swift
HBToast.toast("666666")
```

```swift
HBToast.toast(UIImageView(image: UIImage(named: "666")))
```

链式调用:

```swift
HBToast.show("666666").dismiss(4).canTouchThrough = true
```


