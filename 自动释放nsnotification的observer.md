### 自动释放NSNotification的Observer的实验

实验了几种做法,有一种做法基本可以实现, 但仅粗略验证, 可能有很多未知的问题. 


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
#### 结果: 实验代码表明, 一个对象的Dealloc方法是先于Associated Objectd的Dealloc方法调用的, 所以在Associated Object的dealloc中去释放通知已经晚了. 


####三、 @神漠、@去疾、@妙玄、@卡迩 讨论方案: 新增一个单例APFakeObserver,  该单例作为所有通知的Observer（中间人）,负责转发消息到真正的Observer去. 该单例weak引用真正的Observer,所以转发消息过去如果Observer已经释放也不会crash. 
---


#### 结果: 实验代码表明, 可以实现,但直接hook NSNotificationCenter的addObserver：... 方法会导致系统内部自己调用某些监听通知的逻辑出问题,导致直接crash,需要进一步排查. 但如果是新增一个方法, 让APFakeObserver来充当中间人进行消息转发,是可以实现的. 测试代码见gitlab. 



####四、 Hook Dealloc 方法来添加移除通知操作,未测试.
---
	
	
	
	
 