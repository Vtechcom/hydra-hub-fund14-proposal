# Hydra Hub - Đề xuất Fund 14

## Tổng quan dự án

**Hydra Hub** là một nền tảng được thiết kế để đơn giản hóa quyền truy cập vào các nút Hydra cho các nhà phát triển và người dùng cuối. Kho lưu trữ này chứa tài liệu, báo cáo cột mốc và bằng chứng hoàn thành cho đề xuất Project Catalyst Fund 14 của chúng tôi.

Mục tiêu cốt lõi là xây dựng một hệ thống có khả năng mở rộng bao gồm **Cổng thông tin người dùng (Consumer Portal)** để quản lý các yêu cầu truy cập và **Bảng điều khiển quản trị (Admin Dashboard)** để phân bổ và giám sát nút.

## Cấu trúc kho lưu trữ

- `milestone-1.md`: Báo cáo hoàn thành và bằng chứng cho Cột mốc 1.
- `milestone-2.md`: Báo cáo hoàn thành và bằng chứng cho Cột mốc 2.
- `milestone-3.md`: Báo cáo hoàn thành và bằng chứng cho Cột mốc 3.
- `ms1/`: Tài liệu hỗ trợ Cột mốc 1 (báo cáo QA, ảnh chụp màn hình, hướng dẫn sử dụng).
- `ms2/`: Tài liệu hỗ trợ Cột mốc 2 (báo cáo bằng chứng, báo cáo QA, ảnh chụp màn hình).
- `ms3/`: Tài liệu hỗ trợ Cột mốc 3 (smart contract thanh toán subscription, báo cáo QA).

## Cột mốc 1: Phát triển Hệ thống Cốt lõi

Cột mốc đầu tiên tập trung vào việc thiết lập cơ sở hạ tầng cốt lõi và giao diện người dùng.

### Các thành phần chính

1.  **Cổng thông tin người dùng (Consumer Portal)**:
    - Đăng ký người dùng và xác thực an toàn.
    - Quản lý hồ sơ.
    - Giao diện gửi yêu cầu truy cập nút Hydra.
    - Thiết kế đáp ứng cho máy tính để bàn và thiết bị di động.

2.  **Bảng điều khiển quản trị (Admin Dashboard)**:
    - Quy trình xem xét và phê duyệt các yêu cầu của người dùng.
    - Giám sát trạng thái phân bổ nút theo thời gian thực.
    - Quản lý người dùng và ghi nhật ký hoạt động.

### Tiêu chí Chấp nhận

- **Kiểm soát truy cập dựa trên vai trò (RBAC)**: Tách biệt nghiêm ngặt giữa vai trò người dùng và quản trị viên.
- **Kiểm soát phân bổ nút**: Quản trị viên có thể trực tiếp phân bổ hoặc thu hồi quyền sử dụng nút.
- **Tích hợp hệ thống**: Tích hợp backend hoàn chỉnh với cơ sở dữ liệu PostgreSQL.
- **Khả năng tương thích**: Đã được xác thực trên Chrome v120+ và Safari v17+.

## Cột mốc 2: Triển khai & Tích hợp Node Provider Đơn

Cột mốc thứ hai tích hợp một nút Hydra provider vào nền tảng và xác thực thông qua kiểm thử developer.

### Các Sản phẩm Chính

1.  **Tích hợp Node Provider**:
    - Nút Hydra provider được đăng ký và quản lý qua Admin Dashboard.
    - Phân bổ nút cho developer thông qua nền tảng.

2.  **Giám sát Runtime & Cảnh báo**:
    - Hiển thị số liệu thời gian thực (CPU, RAM, độ trễ mạng, hoạt động giao dịch).
    - Hệ thống cảnh báo khi sức khỏe nút suy giảm.

3.  **Kiểm thử Developer**:
    - 5 developer bên ngoài thực hiện đầy đủ chu trình thao tác Hydra.
    - Các thao tác được kiểm thử: Head Open, UTXO Commit, Transaction, Fanout.

4.  **Xác nhận Uptime**:
    - Nút duy trì hoạt động liên tục 24 giờ.

### Tiêu chí Chấp nhận

- Nút provider được đăng ký và hiển thị trong Admin Dashboard.
- Giám sát runtime và cấu hình cảnh báo hoạt động.
- Tất cả 5 developer hoàn thành thành công các thao tác Hydra.
- Phản hồi developer được thu thập qua GitHub issue.

## Cột mốc 3: Thanh toán Subscription On-chain

Cột mốc thứ ba triển khai hệ thống thanh toán on-chain cho nâng cấp subscription sử dụng smart contract Aiken.

### Các Sản phẩm Chính

1.  **Phát triển Smart Contract**:
    - Validator `timed_deposit` Aiken cho cơ chế khóa thanh toán.
    - Khoảng tranh chấp 24 giờ để bảo vệ hoàn tiền.
    - Triển khai trên mạng thử nghiệm Pre-Production Cardano.

2.  **Các Thao tác Thanh toán**:
    - **Buy (Khóa)**: Người dùng khóa ADA để nâng cấp subscription.
    - **Refund**: Admin có thể hoàn tiền trong khoảng tranh chấp.
    - **Claim**: Admin nhận tiền sau khoảng tranh chấp.

3.  **Tích hợp Nền tảng**:
    - Phản ánh trạng thái thanh toán trong nâng cấp tài khoản người dùng.
    - Dashboard admin để quản lý thanh toán.

4.  **Chi tiết Smart Contract**:
    - **Script Hash**: `41631ceb642272fbf20a2de0563b472f0d83cf78ca5c9b5708c94b9f`
    - **Phiên bản Plutus**: V3
    - **Trình biên dịch**: Aiken v1.1.21

### Tiêu chí Chấp nhận

- Smart contract triển khai trên testnet preprod Cardano.
- Giao dịch on-chain thành công: Buy, Refund, Claim.
- Xác thực thời gian thực thi khoảng tranh chấp 24 giờ.
- Tích hợp nền tảng phản ánh trạng thái thanh toán trong nâng cấp tài khoản.
- Tất cả test case đạt với tỷ lệ thành công 100%.

### Tài liệu

- [Báo cáo Bằng chứng Cột mốc 3](./milestone-3.md)
- [Báo cáo QA (EN)](./ms3/qa-report/readme.md) | [(VI)](./ms3/qa-report/readme-vi.md)
- [Mã nguồn Smart Contract](./ms3/payment-subscription/validators/timed_deposit.ak)
- [Blueprint đã Biên dịch](./ms3/payment-subscription/plutus.json)

---

_Đã gửi cho Cardano Project Catalyst Fund 14_
