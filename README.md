# 短险卡记录软件

基于 Flutter/Dart 的 Android 短险卡记录应用。

## 已实现功能
- Material Design 3 主题与深浅色切换
- 底部导航：记录 / 设置
- 短险卡记录的新增、编辑、详情、删除
- 本地持久化存储（Hive）
- 记录搜索（姓名、证件号、保单号、保险类型）
- JSON 导入 / 导出
- 数据清空
- 关于页与版本信息
- 空状态与基础错误提示

## 主要目录
```text
lib/
├── app/
├── features/
│   ├── records/
│   └── settings/
└── shared/
```

## 启动方式
1. 安装 Flutter SDK
2. 在项目根目录执行：
   - `flutter pub get`
   - `flutter run`

## 说明
当前仓库根据策划书完成了首版可交付骨架，适合作为 MVP 继续迭代。

