# AutoRemoveObserverDemo
### 自动释放NSNotification的Observer的实验

实验了几种做法,其中二和三可以实现, 但仅粗略验证, 可能有未知的问题. 


####一、@妙玄 提供思路：外层包装一个Wrapper对象来感知Observer的释放,通过Wrapper对象来移除通知. 
---

1. NSNotificationCenter加一个category, 添加一个associatedObject为一个数组. 
2. 替换NSNotificationCenter的 addObserver... 方法, 新方法中用一个 Wrapper对象来封装传进来的Observer. 
3. 想通过真正的observer被释放时触发wrapper的 realObserver setter方法, 从而移除通知.

	
	```
	//Wrapper.h
	
	@interface Wrapper : NSObject 
	
	@property (nonatomic, weak) id realObserver;
	@property (nonatomic, assign) id assignObserver;
	
	@end 
	
	
	@implemantation Wrapper
	
	
	- (void)setRealObserver:(id)observer
	{
		if(nil == observer ){
			if(self.assignObserver){
			[[NSNotificationCenter defaultCenter] removerObserver:self.assignObserver];
			self.assignObserver = nil;
			}
		}
		
		_realObserver = observer;
	}
	
	@end 
	
	```
	
	```
	
	// NSNotificationCenter(Hooked).m 
	
	- (void)hooed_addObserver:(id)observer ... 
	{
		Wrapper *wrapper = [[Wrapper alloc] init];
		wrapper.realObserver = observer;
		wrapper.assignObserver = observer;
		[self.wrapperArray addObject:wrapper];// wrapper array 是NSNotificationCenter defaultCenter的一个associated object . 
		
		[self origin_addObserver:observer ...];
	}
	
	```
	
#### 结果: 实验代码表明, Wrapper对象的一个weak属性指向的对象被释放时,不会调用Wrapper对象的setter方法,没有时机移除通知. 



####二、@卡迩 提供思路：给每一个Observer添加一个Associated object 如`AssO`, `AssO`一个weak属性指向Observer,试图通过Observer释放时会先释放`AssO`, 从而在`AssO`的dealloc中通过weak移除Observer. 
---
~~#### 结果: 实验代码表明, 一个对象的Dealloc方法是先于Associated Objectd的Dealloc方法调用的, 所以在Associated Object的dealloc中去释放通知已经晚了. 
~~
### 这个思路可以调整一下,可以在AssociatedObject 的dealloc 方法中调用一个预定的block来移除通知

####三、 @神漠、@去疾、@妙玄、@卡迩 讨论方案: 新增一个单例APFakeObserver,  该单例作为所有通知的Observer（中间人）,负责转发消息到真正的Observer去. 该单例weak引用真正的Observer,所以转发消息过去如果Observer已经释放也不会crash. 
---


#### 结果: 实验代码表明, 可以实现测试代码见[gitlab](https://github.com/JasonWorking/AutoRemoveObserverDemo)(家里连不上VPN,先传github了). 



####四、 Hook Dealloc 方法来添加移除通知操作,未测试.
---

#### 如果不加区分地去hook dealloc方法,会带来过多不必要的开销.暂不考虑这种做法. 
	
	
	
	
 