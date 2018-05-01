# ChildViewControllerDemo

<img src="https://cdn.rawgit.com/sishenyihuba/ChildViewControllerDemo/master/Pic/ChildViewController.gif" width = "300"/>

Using Child ViewController to avoid massive ViewController and separate loadingView or Error Handle View into different parts 


> 在 iOS 开发过程中，经常遇到这种需求，构建一个公用的功能以供多个 ViewController 使用。这里我们在构建这个公用功能模块的时候，需要考虑到两方面。 一：减少代码重复； 二：避免产生Massive ViewController

​	一个常见的使用场景就是，构建一个公用的 Loading 加载视图，和一个Error Handling 错误处理模块。今天的 Blog 就讲一讲使用如何 Child ViewController 来构建这两个公用模块。

​	思考：我们可以把这些公用模块的代码放在那里？ 

### 方案一：我们可以在基类完成公用模块的封装

```swift
class BaseViewController: UIViewController {
    func showActivityIndicator() {
        ...
    }

    func hideActivityIndicator() {
        ...
    }

    func handle(_ error: Error) {
        ...
    }
}
```

方案一优点和缺点：

- 优点： 只要继承了基类 BaseViewController 的子类就都能使用这个公用模块了。
- 缺点：如果我们的 ViewController 想要继承于 UITablewViewController ，岂不是没法使用这个公用模块了，不太灵活。
- 因为不够灵活，我们考虑使用从iOS5之后引入的 Child ViewController 的 Featrue。

### 方案二：使用  Child ViewController 将我们的公用模块作为 'Plugin' 链接进来

用 Child ViewController 比基类显示加载视图的好处在于：任何 ViewController 想要展示一个加载视图，只需要把 LoadingViewController 作为 **Child** 添加进来即可.

- 首先定义一个 ViewController 用来展示加载视图,其中**这个VC有自己的生命周期**，我们添加一个菊花即可。

```Swift
class LoadingViewController: UIViewController {
    private lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // We use a 0.5 second delay to not show an activity indicator
        // in case our data loads very quickly.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
}
```

- 添加和移除 Child VC

  - [ ] 添加 Child VC： 

  ```swift
  // Add the view controller as a child
  addChildViewController(child)

  // Move the child view controller's view to the parent's view
  view.addSubview(child.view)

  // Notify the child that it was moved to a parent
  child.didMove(toParentViewController: self)
  ```

  - [ ] 移除 Child VC：

  ```swift
  // Notify the child that it's about to be moved away from its parent
  child.willMove(toParentViewController: nil)

  // Remove the child
  child.removeFromParentViewController()

  // Remove the child view controller's view from its parent
  child.view.removeFromSuperview()
  ```

- 每次需要添加 Child VC如果都需要写上面三行代码就太麻烦了，我们写一个 UIViewController 的 Extension ，封装两个方法add(_ childVC: UIViewController )  remove()，其他任何想要添加或者移除 Child VC，调用这两个封装的方法即可。

```Swift
extension UIViewController {
    func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
}
```



- 上面准备工作都做好了，开始使用 Child VC吧

```Swift
 let loadingVC = LoadingViewController()

    self.add(loadingVC)

    //开始网络请求，加载数据

    dataLoader.loadItems(failedWithError: { [weak self] (error) in

      //拿到返回结果之后remove掉菊花

      loadingVC.remove()

      //展示错误视图

      if (error != nil) {

          self?.showError()

      } else {

        //没有错误，提示成功

        self?.errorVC.remove()

        self?.resultTextView.text = "这是我获取的正确数据：请关注我的简书Blog：https://www.jianshu.com/u/395eedc160ca"

        self?.loadDataButton.isHidden = true

      }

    })

  }

```

   

- Error View 原理相同，详细代码请见Github链接

https://github.com/sishenyihuba/ChildViewControllerDemo


### 总结

​	使用 Child ViewController可以使得控制器的代码规模降低，降低各个模块之间耦合性，把某一个特定功能的模块封装起来，达到一次Coding，多处多次使用的效果。 在工作中，大家也可以多思考思考什么情况下，可以把某个模块封装成一个Child ViewController，然后插入到其他 ViewController 中使用
