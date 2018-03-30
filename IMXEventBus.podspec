Pod::Spec.new do |s|
  s.name         = "IMXEventBus"
  s.version      = "1.0.0"
  s.summary      = "a delightful EventBus for Object-C"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/PanZhow/IMXEventBus"
  s.author             = { "zhoupanpan" => "2331838272@qq.com" }
  s.source       = { :git => "https://github.com/PanZhow/IMXEventBus.git", :tag => "#{s.version}" }
  s.requires_arc = true

  s.public_header_files = [
    'IMXEventBus/IMXEventBus/*{h}',
    'IMXEventBus/IMXEventBus/Debug/*{h}',
    'IMXEventBus/IMXEventBus/Action/*{h}',
    'IMXEventBus/IMXEventBus/Objs/*{h}',
    'IMXEventBus/IMXEventBus/Event/*{h}',
    ]
  s.source_files = [
    'IMXEventBus/IMXEventBus/*{h,m}',
    'IMXEventBus/IMXEventBus/Debug/*{h,m}',
    'IMXEventBus/IMXEventBus/Action/*{h,m}',
    'IMXEventBus/IMXEventBus/Objs/*{h,m}',
    'IMXEventBus/IMXEventBus/Event/*{h,m}',
]

  s.platform     = :ios, '8.0'

end
