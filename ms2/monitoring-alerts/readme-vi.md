# Báo cáo Giám sát & Xác minh Cảnh báo

**Dự án:** Hydra Hub (Fund14)  
**Milestone ID:** 1400060  
**Giai đoạn:** Milestone 2 - Single Provider Node Deployment & Integration  
**Ngày báo cáo:** 12/03/2026  
**Người thực hiện:** Hydra Hub Development Team  

---

## 1. Tóm tắt Tổng quan (Executive Summary)

Tài liệu này cung cấp bằng chứng về bảng điều khiển giám sát hệ thống và xác minh cảnh báo cho nút Hydra provider được tích hợp vào nền tảng Hydra Hub. Bảng điều khiển quản trị hiển thị các chỉ số thời gian thực bao gồm CPU, RAM, độ trễ mạng và thời gian hoạt động. Hệ thống cảnh báo kích hoạt thông báo thành công khi tình trạng nút suy giảm.

**Kết quả chung:** ✅ **PASSED (ĐẠT)**

---

## 2. Bảng điều khiển Giám sát Hệ thống (System Monitoring Dashboard)

### 2.1. Hiển thị Chỉ số Thời gian thực (Real-Time Metrics Display)

Bảng điều khiển quản trị cung cấp giao diện giám sát toàn diện với các chỉ số thời gian thực sau:

| Chỉ số | Mô tả | Trạng thái |
|--------|--------|-----------|
| CPU Usage | Mức sử dụng CPU theo thời gian thực (%) | ✅ Giám sát hoạt động |
| RAM Usage | Mức sử dụng bộ nhớ RAM theo thời gian thực | ✅ Giám sát hoạt động |
| Network Latency | Độ trễ mạng (ms) | ✅ Giám sát hoạt động |
| Uptime | Thời gian hoạt động liên tục | ✅ Giám sát hoạt động |
| Transaction Throughput | Thông lượng xử lý giao dịch | ✅ Giám sát hoạt động |

### 2.2. Ảnh chụp Chỉ số Nút Nhà cung cấp (Provider Node Metrics Screenshot)

![Provider Node Metrics - Real-time Monitoring](../screenshots/admin-dashboard/provider-node-metrics.png)

### 2.3. Ảnh chụp Trạng thái Nút Nhà cung cấp (Provider Node Status Screenshot)

![Provider Node Status - Uptime](../screenshots/admin-dashboard/provider-node-status.png)

---

## 3. Xác minh Hệ thống Cảnh báo (Alert System Verification)

### 3.1. Cấu hình Cảnh báo (Alert Configuration)

Giao diện quản trị bao gồm cơ chế cảnh báo để thông báo cho quản trị viên khi tình trạng nút suy giảm. Các điều kiện cảnh báo được cấu hình như sau:

| Loại cảnh báo | Điều kiện kích hoạt | Mức độ | Trạng thái |
|---------------|---------------------|--------|-----------|
| Nút không thể truy cập | Nút không phản hồi kiểm tra sức khỏe | **Critical** | ✅ Hoạt động |
| CPU vượt ngưỡng | Mức sử dụng CPU vượt ngưỡng cấu hình | **Warning** | ✅ Hoạt động |
| RAM vượt ngưỡng | Mức sử dụng RAM vượt ngưỡng cấu hình | **Warning** | ✅ Hoạt động |
| Độ trễ mạng cao | Độ trễ mạng vượt phạm vi cho phép | **Warning** | ✅ Hoạt động |

### 3.2. Ảnh chụp Hệ thống Cảnh báo (Alert System Screenshot)

![Provider Alert System](../screenshots/provider-alert.png)

### 3.3. Kết quả Kiểm thử Cảnh báo (Alert Test Results)

| ID | Trường hợp kiểm thử | Kết quả mong đợi | Trạng thái |
|----|---------------------|-----------------|-----------|
| TC09 | Cảnh báo node không thể kết nối | Cảnh báo Critical khi node không thể truy cập | ✅ **ĐẠT** |
| TC10 | Cảnh báo CPU vượt ngưỡng | Cảnh báo Warning khi CPU vượt ngưỡng cho phép | ✅ **ĐẠT** |
| TC11 | Cảnh báo RAM vượt ngưỡng | Cảnh báo Warning khi RAM vượt ngưỡng cho phép | ✅ **ĐẠT** |

---

## 4. Tóm tắt Chỉ số Hiệu năng (Performance Metrics Summary)

Trong giai đoạn thử nghiệm 24 giờ, các chỉ số hiệu năng sau đã được ghi nhận:

| Chỉ số | Giá trị quan sát |
|--------|------------------|
| Trạng thái nút | Active |
| CPU trung bình | ~30% |
| RAM trung bình | ~50% |
| Độ trễ mạng | ~50 ms |
| Độ trễ giao dịch trung bình | ~0.5 giây |
| Tỷ lệ thành công giao dịch | ~99% |
| Thời gian hoạt động | 24+ giờ liên tục |

### 4.1. Nhật ký Trạng thái Nút Hydra — Bằng chứng Hoạt động Liên tục

Nhật ký trạng thái nút Hydra ([`state`](../state)) cung cấp bằng chứng giám sát bổ sung với 8.148 sự kiện được ghi nhận trong ~45 giờ:

- **5.802 sự kiện `TickObserved`** — Đồng bộ slot chuỗi liên tục xác nhận kết nối L1 không gián đoạn
- **54 sự kiện `ChainRolledBack`** — Rollback chuỗi được xử lý trơn tru mà không gián đoạn dịch vụ
- **1 `NetworkConnected` + 1 `PeerConnected`** — Kết nối mạng và peer ổn định được duy trì

> File nhật ký trạng thái gốc: [`state`](../state)

---

## 5. Khả năng Giám sát (Monitoring Capabilities)

### 5.1. Tính năng Bảng điều khiển (Dashboard Features)

- **Cập nhật dữ liệu thời gian thực** — Chỉ số tự động cập nhật không cần làm mới thủ công
- **Xem dữ liệu lịch sử** — Khả năng xem dữ liệu hiệu suất trong quá khứ
- **Chỉ báo sức khỏe nút** — Chỉ báo trạng thái trực quan (xanh/vàng/đỏ)
- **Hệ thống thông báo cảnh báo** — Cảnh báo tự động dựa trên ngưỡng có thể cấu hình

### 5.2. Các Thành phần Được Giám sát (Monitored Components)

| Thành phần | Chỉ số Thu thập |
|-----------|-----------------|
| `cardano-node` | Trạng thái đồng bộ, chiều cao block, kết nối peer |
| `hydra-node` | Trạng thái Head, số lượng giao dịch, trạng thái kết nối |
| Máy chủ | CPU, RAM, disk I/O, băng thông mạng |
| API Gateway | Số lượng request, thời gian phản hồi, tỷ lệ lỗi |

---

## 6. Kết luận (Conclusion)

Hệ thống giám sát và cảnh báo cho nền tảng Hydra Hub đã hoạt động đầy đủ. Bảng điều khiển quản trị cung cấp khả năng hiển thị toàn diện theo thời gian thực về hiệu suất nút, và hệ thống cảnh báo nhận diện chính xác và thông báo cho quản trị viên về các sự kiện suy giảm sức khỏe.

Tất cả tiêu chí chấp nhận giám sát và cảnh báo đã được đáp ứng.

---

**Tài liệu liên quan:**
- [Báo cáo Bằng chứng Chính](../MILESTONE-2-EVIDENCE-REPORT.md)
- [Báo cáo Triển khai Máy chủ (EN)](../server-deployment/readme.md)
- [Báo cáo Tích hợp Hydra Hub (EN)](../hydra-hub-integration/readme.md)
- [Báo cáo Thử nghiệm Nhà phát triển (EN)](../developer-testing/readme.md)
- [Báo cáo QA (EN)](../qa-report/readme.md)
