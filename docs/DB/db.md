# Period Limited Database Foundation

Version: v1.1

Status: Completed (Milestone M1)

---

# 專案資訊

**專案名稱**

期間限定（Period Limited）

**Repository**

* period-limited-api（Backend / .NET 8 Web API）
* period-limited-admin（Frontend / Vue3 + Vuetify）
* period-limited-client（Frontend / Vue3 + Vuetify）

---

# Database 環境

## DB 類型

SQL Server LocalDB

## Instance

```text
(localdb)\MSSQLLocalDB
```

## Database

```text
PeriodLimitedDb_Dev
```

---

# 建立目的

本資料庫僅供「期間限定」專案本機開發使用。

與公司環境完全隔離。

---

# 開發原則

* 不使用公司 SQL Server Instance
* 不修改公司任何 Database
* 不開啟 TCP/IP 對外連線
* 採本機 LocalDB 開發
* 資料庫可採 SQL Script 或 EF Core Migration 維護
* DB Schema 以本文件及 ERD 為唯一依據

---

# Milestone

## M1 - Database Foundation

Status

```text
Completed
```

Deliverables

* ERD v1
* Database Schema
* Seed Data
* SQL Script
* LocalDB 建立完成
* Database 驗證完成

---

# Database Schema

目前包含以下 Table：

```text
SYS_CD
User
Category
Region
Tag
Event
EventTag
```

---

# Table 說明

| Table    | 說明      |
| -------- | ------- |
| SYS_CD   | 系統共用代碼  |
| User     | 後台管理者   |
| Category | 活動分類    |
| Region   | 活動地區    |
| Tag      | 活動標籤    |
| Event    | 活動主檔    |
| EventTag | 活動與標籤關聯 |

---

# SYS_CD 類型

目前已建立：

```text
AREA
EVENT_TYPE
CONTENT_STATUS
PERIOD_STATUS
USER_ROLE
```

---

# 共用欄位規範

所有主檔(Table)統一採用：

| 中文   | 英文         |
| ---- | ---------- |
| 建立時間 | CreateDate |
| 建立人員 | CreateUser |
| 修改時間 | ModifyDate |
| 修改人員 | ModifyUser |
| 刪除時間 | DeleteDate |
| 刪除人員 | DeleteUser |

---

# Flag 規範

## EnableFlag

```text
0 = 正常
1 = 停用
```

## DeleteFlag

```text
0 = 正常
1 = 已刪除
```

---

# 命名規範

## Table

使用 PascalCase

例如：

```text
Event
Category
Region
EventTag
```

---

## Column

使用 PascalCase

例如：

```text
Title
Summary
StartDate
EndDate
CategoryId
CreateDate
ModifyUser
```

---

# Repository

```text
period-limited-api
```

負責：

* Web API
* Business Logic
* Database
* EF Core
* Scheduler

---

```text
period-limited-admin
```

負責：

* 後台管理系統
* 活動管理
* 主檔管理
* 使用者管理

---

```text
period-limited-client
```

負責：

* 使用者前台
* 活動查詢
* 活動詳情
* 搜尋
* 收藏（後續 Milestone）

---

# 驗收結果

已完成：

* Database 建立完成
* LocalDB 建立完成
* Table 建立完成
* SYS_CD Seed Data 建立完成
* Database 驗證完成

---

# Git Commit

```text
feat(db): complete database foundation v1
```

---

# 下一個 Milestone

## M2 - Backend Foundation

內容：

* 建立 Solution Structure
* 建立 分層架構
* Entity
* DbContext
* Repository Pattern
* Dependency Injection
* Exception Middleware
* Swagger
* Logging
* Configuration
* EF Core Configuration

完成後才開始開發第一支 API。
