# Hydra Hub - Đề xuất Fund 14

## Tổng quan dự án
**Hydra Hub** là một nền tảng được thiết kế để đơn giản hóa quyền truy cập vào các nút Hydra cho các nhà phát triển và người dùng cuối. Kho lưu trữ này chứa tài liệu, báo cáo cột mốc và bằng chứng hoàn thành cho đề xuất Project Catalyst Fund 14 của chúng tôi.

Mục tiêu cốt lõi là xây dựng một hệ thống có khả năng mở rộng bao gồm **Cổng thông tin người dùng (Consumer Portal)** để quản lý các yêu cầu truy cập và **Bảng điều khiển quản trị (Admin Dashboard)** để phân bổ và giám sát nút.

## Cột mốc 1: Phát triển hệ thống cốt lõi

Cột mốc đầu tiên của chúng tôi tập trung vào việc thiết lập cơ sở hạ tầng cốt lõi và giao diện người dùng.

### Các thành phần chính
1.  **Cổng thông tin người dùng (Consumer Portal)**: 
    *   Đăng ký người dùng và xác thực an toàn.
    *   Quản lý hồ sơ.
    *   Giao diện gửi yêu cầu truy cập nút Hydra.
    *   Thiết kế đáp ứng cho máy tính để bàn và thiết bị di động.

2.  **Bảng điều khiển quản trị (Admin Dashboard)**:
    *   Quy trình xem xét và phê duyệt các yêu cầu của người dùng.
    *   Giám sát trạng thái phân bổ nút theo thời gian thực.
    *   Quản lý người dùng và ghi nhật ký hoạt động.

### Chức năng và tiêu chí chấp nhận
*   **Kiểm soát truy cập dựa trên vai trò (RBAC)**: Tách biệt nghiêm ngặt giữa vai trò người dùng và quản trị viên.
*   **Kiểm soát phân bổ nút**: Quản trị viên có thể trực tiếp phân bổ hoặc thu hồi quyền sử dụng nút.
*   **Tích hợp hệ thống**: Tích hợp phụ trợ hoàn chỉnh với cơ sở dữ liệu PostgreSQL (quản lý người dùng, yêu cầu, phân bổ).
*   **Khả năng tương thích**: Đã được xác thực trên Chrome v120+ và Safari v17+, hỗ trợ bố cục đáp ứng (1920x1080 và 375x812).

## Cấu trúc kho lưu trữ

*   `milestone-1.md`: Mẫu báo cáo hoàn thành và bằng chứng cho Cột mốc 1.
*   *(Các báo cáo cột mốc trong tương lai sẽ được thêm vào đây)*

## Triển khai và thử nghiệm

Chúng tôi duy trì hai môi trường cho giai đoạn này:

*   **Môi trường thử nghiệm Alpha**: Để thử nghiệm chức năng và phản hồi của người dùng.
*   **Bản demo Backoffice**: Truy cập hạn chế cho các quy trình làm việc hành chính.

## Tổng quan về API

Hệ thống dựa vào một API phụ trợ mạnh mẽ xử lý các hoạt động chính:

*   **Xác thực (Auth)**: `/api/auth/register`, `/api/auth/login`
*   **Yêu cầu (Requests)**: `GET/POST /api/requests`
*   **Quản trị (Admin)**: `/api/admin/requests/:id`, `/api/admin/nodes`

---
*Đã gửi cho Cardano Project Catalyst Fund 14*
