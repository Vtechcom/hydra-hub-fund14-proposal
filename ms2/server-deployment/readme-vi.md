# Báo cáo Triển khai và Cấu hình Máy chủ

**Dự án:** Hydra Hub (Fund14)  
**Milestone ID:** 1400060  
**Giai đoạn:** Milestone 2 - Single Provider Node Deployment & Integration  
**Ngày báo cáo:** 12/03/2026  
**Người thực hiện:** Hydra Hub Development Team  

---

## 1. Tóm tắt Tổng quan (Executive Summary)

Tài liệu này cung cấp bằng chứng về việc triển khai và cấu hình máy chủ cho nút Hydra provider được tích hợp vào nền tảng Hydra Hub. Nút đã được triển khai, cấu hình và duy trì hoạt động ổn định trong suốt giai đoạn thử nghiệm tối thiểu **24 giờ liên tục**.

**Kết quả chung:** ✅ **PASSED (ĐẠT)**

---

## 2. Tổng quan Kiến trúc (Architecture Overview)

Hydra Hub không trực tiếp vận hành các nút hạ tầng Hydra. Thay vào đó, nền tảng cho phép các nhà cung cấp hạ tầng đăng ký nút Hydra và cung cấp cho nhà phát triển thông qua lớp truy cập được quản lý.

Kiến trúc hệ thống bao gồm ba thành phần chính:

| Thành phần | Mô tả |
|-----------|-------|
| **Lớp nhà cung cấp (Provider Layer)** | Các nút Hydra được vận hành bởi nhà cung cấp hạ tầng, kết nối với Cardano Layer 1 |
| **Nền tảng Hydra Hub (Hydra Hub Platform)** | Đăng ký nút, phân bổ truy cập, giám sát, xác thực người dùng |
| **Lớp người tiêu dùng (Consumer Layer)** | Nhà phát triển kết nối dApp thông qua Hydra Hub |

### Luồng hệ thống

```
[Cardano L1] ← → [Hydra Node (Provider)] ← → [Hydra Hub Platform] ← → [Developer dApps]
```

---

## 3. Cấu hình Máy chủ (Server Configuration)

### 3.1. Hạ tầng nút (Node Infrastructure)

| Thông số | Chi tiết |
|----------|---------|
| Loại nút | Hydra Provider Node |
| Mạng | Cardano Preview Testnet |
| Phiên bản Hydra Node | Tương thích với phiên bản Cardano node hiện tại |
| Phương thức triển khai | Docker containerized deployment |
| Giám sát | Tích hợp với Hydra Hub Admin Dashboard |

### 3.2. Các dịch vụ đang chạy (Services Running)

| Dịch vụ | Trạng thái |
|---------|-----------|
| `cardano-node` | ✅ Đang chạy |
| `hydra-node` | ✅ Đang chạy |
| Hydra Hub API Gateway | ✅ Đang chạy |
| Monitoring Agent | ✅ Đang chạy |

---

## 4. Bằng chứng hoạt động ổn định 24 giờ liên tục (24-Hour Continuous Uptime Evidence)

Nút mạng đã duy trì hoạt động trong suốt giai đoạn thử nghiệm tối thiểu 24 giờ liên tục mà không có bất kỳ gián đoạn nào.

### 4.1. Terminal nút đang chạy (Node Terminal Running)

![Node Terminal Running](../screenshots/node-running/node-terminal-running.png.png)

### 4.2. Bằng chứng Uptime - Thời điểm 18:21 (2026-03-11)

![Node Running Evidence 1 - 2026-03-11 18:21](../screenshots/node-running/Screenshot%20from%202026-03-11%2018-21-57.png)

### 4.3. Bằng chứng Uptime - Thời điểm 18:22 (2026-03-11)

![Node Running Evidence 2 - 2026-03-11 18:22](../screenshots/node-running/Screenshot%20from%202026-03-11%2018-22-30.png)

### 4.4. Nhật ký Trạng thái Nút Hydra (Hydra Node State Log)

File nhật ký trạng thái nút Hydra ([`state`](../state)) cung cấp bản ghi đầy đủ, có thể đọc bằng máy về tất cả sự kiện nút trong giai đoạn thử nghiệm.

**Tóm tắt Nhật ký:**

| Thông số | Giá trị |
|----------|--------|
| File nhật ký | [`state`](../state) (định dạng JSON Lines) |
| Khoảng thời gian | `2026-03-10T11:37:33Z` → `2026-03-12T08:25:29Z` |
| Thời lượng | ~44 giờ 48 phút |
| Tổng sự kiện | 8.148 |
| Sự kiện đầu tiên | `NetworkConnected` — Nút kết nối mạng |
| Peer kết nối | `hexcore-hydra-node-84:11006` |

**Phân bổ Sự kiện:**

| Loại sự kiện | Số lượng | Mô tả |
|-------------|---------|-------|
| `TickObserved` | 5.802 | Tick slot chuỗi được quan sát (đồng bộ L1 liên tục) |
| `DepositExpired` | 2.252 | Sự kiện hết hạn deposit |
| `ChainRolledBack` | 54 | Sự kiện rollback chuỗi |
| `IgnoredHeadInitializing` | 21 | Lọc khởi tạo Head |
| `PartySignedSnapshot` | 3 | Sự kiện ký snapshot |
| `DepositRecorded` | 2 | Sự kiện ghi nhận deposit |
| `CommittedUTxO` | 2 | Xác nhận cam kết UTxO |
| `HeadInitialized` | 1 | Khởi tạo Head |
| `HeadOpened` | 1 | Xác nhận mở Head |
| `TransactionReceived` | 1 | Giao dịch nhận trong Head |
| `TransactionAppliedToLocalUTxO` | 1 | Giao dịch áp dụng cục bộ |
| `SnapshotConfirmed` | 1 | Snapshot được xác nhận |
| `HeadClosed` | 1 | Đóng Head |
| `HeadIsReadyToFanout` | 1 | Sẵn sàng fanout |
| `HeadFannedOut` | 1 | Hoàn thành fanout |
| `NetworkConnected` | 1 | Kết nối mạng ban đầu |
| `PeerConnected` | 1 | Kết nối peer được thiết lập |

Luồng sự kiện `TickObserved` liên tục (5.802 tick) xác nhận nút đã duy trì đồng bộ không gián đoạn với chuỗi Cardano L1 trong suốt toàn bộ giai đoạn thử nghiệm.

---

## 5. Kết quả Xác minh Uptime (Uptime Validation Results)

| Trường hợp kiểm thử | Kết quả mong đợi | Trạng thái |
|---------------------|-----------------|-----------|
| Hoạt động liên tục 24 giờ | Nút duy trì hoạt động ổn định ≥24 giờ | ✅ **ĐẠT** |
| Log hệ thống trong thời gian uptime | Log hydra-node và cardano-node được ghi nhận liên tục | ✅ **ĐẠT** |
| Không khởi động lại bất ngờ | Tiến trình nút chạy không bị crash hoặc restart | ✅ **ĐẠT** |
| Duy trì kết nối mạng | Kết nối ổn định với Cardano L1 xuyên suốt | ✅ **ĐẠT** |

---

## 6. Kết luận (Conclusion)

Nút Hydra provider đã được triển khai và cấu hình thành công. Nút đã chứng minh **hoạt động ổn định, không gián đoạn trong toàn bộ giai đoạn thử nghiệm 24 giờ liên tục**, đáp ứng yêu cầu uptime được định nghĩa trong tiêu chí chấp nhận Milestone 2.

Việc triển khai máy chủ cung cấp nền tảng đáng tin cậy cho nhà phát triển truy cập và thực hiện các thao tác Hydra thông qua nền tảng Hydra Hub.

---

**Tài liệu liên quan:**
- [Báo cáo Bằng chứng Chính](../MILESTONE-2-EVIDENCE-REPORT.md)
- [Báo cáo QA (EN)](../qa-report/readme.md)
- [Báo cáo QA (VI)](../qa-report/readme-vi.md)
